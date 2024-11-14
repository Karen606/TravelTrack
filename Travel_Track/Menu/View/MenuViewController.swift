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
//        navigationController?.navigationItem.hidesBackButton = true
//        self.navigationController?.navigationItem.setHidesBackButton(true, animated:true)

        setupUI()
    }
    
    func setupUI() {
//        navigationController?.navigationBar.isHidden = false
        titleLabels.forEach({ $0.font = .architects(size: 15)})
        countriesLabel.font = .architects(size: 24)
        citiesLabel.font = .architects(size: 24)
        friendsLabel.font = .architects(size: 24)
    }

    @IBAction func clickedCalendar(_ sender: UIButton) {
        self.pushViewController(CalendarViewController.self)
    }
}
