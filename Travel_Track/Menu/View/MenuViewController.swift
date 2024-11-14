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
    private let viewModel = MenuViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMyTravels { [weak self] travels, _ in
            guard let self = self else { return }
            let uniqueCountries = Set(travels.compactMap { $0.country?.lowercased() })
            let uniqueCities = Set(travels.compactMap { $0.city?.lowercased() })
            self.countriesLabel.text = "\(uniqueCountries.count)"
            self.citiesLabel.text = "\(uniqueCities.count)"
        }
        
        viewModel.fetchFriendTravels { [weak self] travels, _ in
            guard let self = self else { return }
            self.friendsLabel.text = "\(travels.count)"
        }
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .architects(size: 15)})
        countriesLabel.font = .architects(size: 24)
        citiesLabel.font = .architects(size: 24)
        friendsLabel.font = .architects(size: 24)
    }

    @IBAction func clickedCalendar(_ sender: UIButton) {
        self.pushViewController(CalendarViewController.self)
    }
    
    @IBAction func clickedMyPlaces(_ sender: UIButton) {
        self.pushViewController(MyTravelsViewController.self)
    }
    
    @IBAction func clickedFriendsPlaces(_ sender: UIButton) {
        self.pushViewController(FriendsTravelsViewController.self)
    }
    
    @IBAction func clickedSettings(_ sender: UIButton) {
    }
}
