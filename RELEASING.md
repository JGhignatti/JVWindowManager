# Releasing a new version

Steps to cut a new release of JV Window Manager, build a `.dmg`, and publish it on GitHub.

The checked-in Xcode project has no `DEVELOPMENT_TEAM` set, so anyone can clone and build it without being part of any team. Archiving a release still needs _some_ signing identity though — see [step 2](#2-build-the-release-and-the-dmg) for how that's handled without committing a team ID to the repo.

## Prerequisites (one-time setup)

- Xcode, with your Apple ID added under **Settings → Accounts** (a free Apple ID is enough — no paid Developer Program membership needed for any of this).
- [Node.js](https://nodejs.org) 20+, for running `create-dmg` via `npx`.
- [GitHub CLI](https://cli.github.com) (optional — only needed for the automated tag/push/publish step):
  ```
  brew install gh
  gh auth login
  ```

## 1. Bump the version

In Xcode, select the **JVWindowManager** target → **General** tab → **Identity**:

- **Version** (`MARKETING_VERSION`) — the user-facing version, e.g. `3.0`. This is what shows up in the About window and the README badge.
- **Build** (`CURRENT_PROJECT_VERSION`) — an internal build counter. It has stayed at `1` since the project started, so bumping it is optional — only do it if you want each build to have a unique build number.

Editing the **Version** field in the General tab updates it for both the Debug and Release configurations in `project.pbxproj` at once. Do this in Xcode, not by hand — editing `project.pbxproj` outside Xcode while it's open risks corrupting the project.

Commit the bump:

```
git add JVWindowManager.xcodeproj/project.pbxproj
git commit -m "chore: bump version to 3.0"
```

## 2. Build the release and the .dmg

Run the release script:

```
scripts/release.sh
```

It reads your Team ID from a `.env` file at the repo root (`TEAM_ID=...`), so you don't have to remember or retype it. `.env` isn't committed (a Team ID isn't secret, it's just a local convenience file) — create it once with:

```
echo "TEAM_ID=<your team id>" > .env
```

Find your Team ID in Xcode → Settings → Accounts, under your Apple ID. You can also pass it directly instead: `scripts/release.sh <TEAM_ID>`.

This:

1. Refuses to run if there are uncommitted changes (so the build always matches a real commit).
2. Archives the app in Release configuration, passing `DEVELOPMENT_TEAM=<TEAM_ID>` as a command-line build setting override — this signs the archive with your team for this build only, without ever writing your team ID into the checked-in project file.
3. Copies the exported `.app` out of the archive into `build/`.
4. Reads the version straight from the built app's `Info.plist`, so the `.dmg` filename and the tag/release name below can never drift out of sync with what you set in step 1. Past releases tag as `X.Y.Z` (e.g. `2.0.0`) even though `MARKETING_VERSION` is `X.Y` (e.g. `2.0`), and the release title adds a `v` the tag itself doesn't have (tag `2.0.0`, title `v2.0.0`) — the script pads and prefixes to match.
5. Builds the `.dmg` via `npx create-dmg` (no global install) and renames it to `build/JVWindowManager_<tag>.dmg` — matching the asset name used on every past release (`JVWindowManager_1.0.0.dmg`, `JVWindowManager_2.0.0.dmg`), not create-dmg's own default name.
6. Writes a draft release description to `build/release-notes.md` — see [step 4](#4-write-the-release-description) for what's in it and what you still need to fill in.
7. If `gh` is installed, pauses so you can edit that file, then offers to tag, push, and publish the GitHub release right there. Say no (or don't have `gh`) and you can still do it manually.

(`build/` is gitignored — it's a scratch directory, safe to delete between releases.)

### Why pass the team ID on the command line instead of setting it in Xcode?

Setting **Signing & Capabilities → Team** in Xcode's UI writes the team ID straight into `project.pbxproj`, which is exactly what you'd have to remember to revert before committing. Passing it as a build setting override on the `xcodebuild archive` command line achieves the same signing for that one archive, but never touches the file at all — nothing to forget, nothing to revert.

## 3. Test the .dmg

- Double-click `build/JVWindowManager_X.Y.Z.dmg`, drag the app into Applications from the mounted volume.
- Launch the copy in `/Applications`.
- Eject the mounted volume when done.

## 4. Write the release description

```
# vX.Y.Z - Actions release

Introduces Actions (default and custom).

**Full Changelog**: https://github.com/JGhignatti/JVWindowManager/compare/A.B.C...X.Y.Z

## Installation

- Download `JVWindowManager_X.Y.Z.dmg` and run it
- Drag and drop JVWindowManager app into the Applications folder
- Open JVWindowManager
- Check "Launch at login"
```

The script's `build/release-notes.md` already has the mechanical parts filled in for you — the `**Full Changelog**` compare link (previous tag → this tag) and the `## Installation` section (with the correct `.dmg` filename). What it can't write for you, because it requires knowing what actually changed:

- The tagline after the title (e.g. `- Actions release`).
- The one- or two-sentence summary of what's new.

Open `build/release-notes.md` and fill in both `TODO` spots before publishing.

## 5. Tag, push, and publish

If you said yes at the end of the script, this already happened — skip to the end.

Otherwise, do it by hand. Existing tags (`1.0.0`, `2.0.0`) have no `v` prefix, but their release
titles do (`v1.0.0`, `v2.0.0`) — keep that convention:

```
git push origin main
git tag -a X.Y.Z -m "X.Y.Z"
git push origin X.Y.Z
gh release create X.Y.Z "build/JVWindowManager_X.Y.Z.dmg" --title "vX.Y.Z" --notes-file build/release-notes.md
```

Without `gh`, do the last step from the web UI instead: **Releases → Draft a new release → choose the `X.Y.Z` tag → title it `vX.Y.Z` → paste in `build/release-notes.md` → attach the `.dmg` → Publish release**.

The README's release badge (`shields.io`, pointed at `releases/latest`) updates automatically — no action needed there.
