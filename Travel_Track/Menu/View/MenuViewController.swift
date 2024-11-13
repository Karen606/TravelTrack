//
//  MenuViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var citiesLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .architects(size: 15)})
        countriesLabel.font = .architects(size: 24)
        citiesLabel.font = .architects(size: 24)
        friendsLabel.font = .architects(size: 24)
    }

}
