//
//  IdentifyWindowModifier.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct IdentifyWindowModifier: ViewModifier {
    let identifier: String

    func body(content: Content) -> some View {
        content
            .background(
                WindowAccessor { window in
                    window?.identifier = NSUserInterfaceItemIdentifier(
                        identifier
                    )
                }
            )
    }
}

private struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        DispatchQueue.main.async {
            self.callback(view.window)
        }
        
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
