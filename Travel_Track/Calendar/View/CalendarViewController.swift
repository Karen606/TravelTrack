//
//  CalendarViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import UIKit
import FSCalendar
import Combine

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    private let viewModel = CalendarViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setNavigationBar(title: "Travel Calendar")
        setNaviagtionMenuButton()
        calendarView.appearance.selectionColor = #colorLiteral(red: 0.7720025182, green: 0.2696399093, blue: 0.2442657351, alpha: 1)
        calendarView.appearance.titleSelectionColor = .white
        calendarView.appearance.todayColor = .clear
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.addShadow()
        subscribe()
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$dates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                guard let self = self else { return }
                self.calendarView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedAddPlace(_ sender: UIButton) {
        self.pushViewController(TravelFormViewController.self)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .baseText
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let isWithinRange = viewModel.dates.contains { range in
            guard range.count == 2 else { return false }
            let start = range[0]
            let end = range[1]
            return date >= start && date <= end
        }
        return isWithinRange ? .baseBlue : nil
    }
}
