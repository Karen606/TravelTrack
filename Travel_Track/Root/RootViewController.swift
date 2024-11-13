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
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.navigationController?.viewControllers = [menuVC]
    }
}
