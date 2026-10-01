#!/bin/bash
#
# Builds a signed Release archive, exports the .app, and packages it as a .dmg.
# Optionally tags, pushes, and publishes the GitHub release too.
#
# Usage:
#   scripts/release.sh [TEAM_ID]
#
# TEAM_ID is your personal Apple Developer Team ID (a free Apple ID account is
# enough — find it in Xcode -> Settings -> Accounts). It's passed as a
# command-line build setting override, so it signs this one archive without
# ever being written into the checked-in Xcode project.
#
# If omitted, TEAM_ID is read from a .env file at the repo root (TEAM_ID=...).
# That file isn't committed — it's just a local reminder since a Team ID isn't
# secret, it's just easy to forget.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

TEAM_ID="${1:-${TEAM_ID:-}}"
if [[ -z "$TEAM_ID" ]]; then
  echo "Usage: scripts/release.sh [TEAM_ID]  (find it in Xcode -> Settings -> Accounts, or set TEAM_ID in .env)" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree isn't clean — commit the version bump first." >&2
  exit 1
fi

BUILD_DIR="$ROOT/build"
ARCHIVE_PATH="$BUILD_DIR/JVWindowManager.xcarchive"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "==> Archiving (signed with team $TEAM_ID for this build only)…"
xcodebuild archive \
  -project JVWindowManager.xcodeproj \
  -scheme JVWindowManager \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  -destination "generic/platform=macOS" \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_STYLE=Automatic

APP_PATH="$BUILD_DIR/JVWindowManager.app"
cp -R "$ARCHIVE_PATH/Products/Applications/JVWindowManager.app" "$APP_PATH"

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist")
echo "==> Built version $VERSION"

# Past releases tag as X.Y.Z (e.g. "2.0.0") even though MARKETING_VERSION is X.Y
# (e.g. "2.0"), and the release title adds a "v" the tag itself doesn't have
# (tag "2.0.0", title "v2.0.0"). Match that convention here.
DOT_COUNT=$(grep -o "\." <<< "$VERSION" | wc -l | tr -d ' ')
if [[ "$DOT_COUNT" -eq 1 ]]; then
  TAG="${VERSION}.0"
else
  TAG="$VERSION"
fi
TITLE="v${TAG}"

echo "==> Building .dmg with create-dmg (via npx)…"
npx create-dmg "$APP_PATH" "$BUILD_DIR" --overwrite

# Rename to match the asset name used on every past release
# (JVWindowManager_1.0.0.dmg, JVWindowManager_2.0.0.dmg) — underscore-separated,
# padded to the tag. create-dmg names its output after the app's
# CFBundleDisplayName ("JV Window Manager X.Y.dmg"), not the target name, so
# find whatever .dmg it just produced instead of guessing the filename.
ASSET_NAME="JVWindowManager_${TAG}.dmg"
ASSET_PATH="$BUILD_DIR/$ASSET_NAME"
CREATED_DMG=$(find "$BUILD_DIR" -maxdepth 1 -name '*.dmg' -print -quit)
mv "$CREATED_DMG" "$ASSET_PATH"
echo "==> Done: $ASSET_PATH"

REPO_SLUG=$(git remote get-url origin | sed -E 's#.*[:/]([^/]+/[^/]+)\.git#\1#')
PREV_TAG=$(git describe --tags --abbrev=0 2>/dev/null || true)

NOTES_PATH="$BUILD_DIR/release-notes.md"
{
  echo "# ${TITLE} - TODO: one-line tagline"
  echo
  echo "TODO: one or two sentences on what's new in this release."
  echo
  if [[ -n "$PREV_TAG" ]]; then
    echo "**Full Changelog**: https://github.com/${REPO_SLUG}/compare/${PREV_TAG}...${TAG}"
    echo
  fi
  echo "## Installation"
  echo
  echo "- Download \`${ASSET_NAME}\` and run it"
  echo "- Drag and drop JVWindowManager app into the Applications folder"
  echo "- Open JVWindowManager"
  echo "- Check \"Launch at login\""
} > "$NOTES_PATH"
echo "==> Draft release notes at $NOTES_PATH — fill in the TODOs before publishing."

if ! command -v gh >/dev/null 2>&1; then
  echo
  echo "gh CLI not found — tag, push, and publish manually. See RELEASING.md."
  exit 0
fi

echo
read -r -p "Edit $NOTES_PATH now, then press enter to continue (or Ctrl-C to stop here)… "

read -r -p "Tag, push, and publish the GitHub release for $TAG ($TITLE) now? [y/N] " REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  git tag -a "$TAG" -m "$TAG"
  git push origin HEAD
  git push origin "$TAG"
  gh release create "$TAG" "$ASSET_PATH" --title "$TITLE" --notes-file "$NOTES_PATH"
  echo "==> Published release $TAG ($TITLE)"
else
  echo "Skipped. Tag, push, and publish manually when ready. See RELEASING.md."
fi
