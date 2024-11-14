//
//  MyTravelsViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import UIKit
import Combine

class MyTravelsViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var travelsTableView: UITableView!
    private let viewModel = MyTravelsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationBar(title: "My places")
        setNaviagtionMenuButton()
        self.navigationItem.setHidesBackButton(true, animated: true)
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.border.cgColor
        searchTextField.delegate = self
        searchTextField.textColor = .baseText
        searchTextField.setupLeftViewIcon(.search, size: CGSize(width: 40, height: 40))
        travelsTableView.register(UINib(nibName: "TravelTableViewCell", bundle: nil), forCellReuseIdentifier: "TravelTableViewCell")
        travelsTableView.delegate = self
        travelsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$travels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] travels in
                guard let self = self else { return }
                self.travelsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension MyTravelsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.filter(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension MyTravelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.travels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        cell.configure(travel: viewModel.travels[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
}

extension MyTravelsViewController: TravelTableViewCellDelegate {
    func remove(id: UUID) {
        viewModel.remove(id: id) { [weak self] error in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
    }
}
