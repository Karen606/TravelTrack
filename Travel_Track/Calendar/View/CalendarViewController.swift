//
//  CalendarViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setNavigationBar(title: "Travel Calendar")
        setNaviagtionMenuButton()
    }
    
    @IBAction func clickedAddPlace(_ sender: UIButton) {
        self.pushViewController(TravelFormViewController.self)
    }
}
