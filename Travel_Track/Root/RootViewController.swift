//
//  RootViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
            }
        }
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.navigationController?.viewControllers = [menuVC]
    }
}
