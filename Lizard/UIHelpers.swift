//
//  UIHelpers.swift
//  Lizard
//

import UIKit

/// Gets the current interface orientation from the active foreground scene.
/// Safe for multi-scene apps (no use of deprecated orientation APIs).
public func currentInterfaceOrientation() -> UIInterfaceOrientation {
    let scenes = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .filter { $0.activationState == .foregroundActive }
    
    guard let windowScene = scenes.first else { return .portrait }
    return windowScene.interfaceOrientation
}

/// Finds the top-most visible view controller in the **active foreground** scene.
/// Safe for multi-scene apps (no use of deprecated `keyWindow`).
public func topViewController() -> UIViewController? {
    // 1) Pick the active foreground UIWindowScene
    let scenes = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .filter { $0.activationState == .foregroundActive }

    guard let windowScene = scenes.first else { return nil }

    // 2) Find the key window in that scene
    guard let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
        // If none is flagged key, fall back to any visible window
        guard let anyWindow = windowScene.windows.first(where: { !$0.isHidden && $0.alpha > 0 }) else { return nil }
        return topViewController(from: anyWindow.rootViewController)
    }

    // 3) Walk down to the presented top-most controller
    return topViewController(from: keyWindow.rootViewController)
}

private func topViewController(from base: UIViewController?) -> UIViewController? {
    guard let base = base else { return nil }

    if let nav = base as? UINavigationController {
        return topViewController(from: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        return topViewController(from: tab.selectedViewController)
    }
    if let presented = base.presentedViewController {
        return topViewController(from: presented)
    }
    return base
}
