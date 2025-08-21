//
//  TransparentSpriteView.swift
//  Lizard
//
//  Created by Ben Towne on 8/16/25.
//


import SwiftUI
import SpriteKit

/// A transparent SKView host so SwiftUI backgrounds show through.
struct TransparentSpriteView: UIViewRepresentable {
    let scene: SKScene
    let preferredFPS: Int

    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        // Transparency & performance
        skView.isOpaque = false
        skView.backgroundColor = .clear
        skView.allowsTransparency = true
        skView.ignoresSiblingOrder = true
        skView.shouldCullNonVisibleNodes = true
        skView.isAsynchronous = true
        skView.preferredFramesPerSecond = preferredFPS
        // Present the scene if not already
        if skView.scene !== scene {
            scene.scaleMode = .resizeFill
            scene.backgroundColor = .clear
            skView.presentScene(scene)
        }
        return skView
    }

    func updateUIView(_ skView: SKView, context: Context) {
        skView.isOpaque = false
        skView.backgroundColor = .clear
        skView.allowsTransparency = true
        skView.preferredFramesPerSecond = preferredFPS
        if skView.scene !== scene {
            scene.scaleMode = .resizeFill
            scene.backgroundColor = .clear
            skView.presentScene(scene)
        }
        // Keep scene sized to the SKView’s bounds
        scene.size = skView.bounds.size
    }
}