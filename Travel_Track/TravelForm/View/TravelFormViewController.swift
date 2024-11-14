//
//  PlaceFormViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import UIKit
import Combine
import DropDown

class TravelFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var countryTextField: BaseTextField!
    @IBOutlet weak var cityTextField: BaseTextField!
    @IBOutlet weak var startDateTextField: BaseTextField!
    @IBOutlet weak var endDateTextField: BaseTextField!
    @IBOutlet weak var feedBackTextField: BaseTextField!
    @IBOutlet weak var visitedButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var visitBgView: UIView!
    @IBOutlet var emojiButtons: [UIButton]!
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let dropDown = DropDown()
    private let viewModel = TravelFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        dropDown.width = visitedButton.bounds.width
        dropDown.bottomOffset = CGPoint(x: visitedButton.frame.minX, y: visitedButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationBar(title: "Add a place")
        setNaviagtionBackButton()
        setNaviagtionMenuButton()
        visitedButton.backgroundColor = .baseWhite
        visitedButton.layer.cornerRadius = 20
        visitedButton.layer.borderWidth = 1
        visitedButton.layer.borderColor = UIColor.baseText.cgColor
        visitedButton.setTitleColor(.baseText, for: .normal)
        startDateTextField.setupRightViewIcon(.arrowDown, size: CGSize(width: 40, height: 40))
        endDateTextField.setupRightViewIcon(.arrowDown, size: CGSize(width: 40, height: 40))
        let fields = [nameTextField, countryTextField, cityTextField, startDateTextField, endDateTextField, feedBackTextField]
        fields.forEach({ $0?.delegate = self })
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .inline
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
    }
    
    func setupDropDown() {
        dropDown.backgroundColor = .baseBlue
        dropDown.layer.cornerRadius = 4
        dropDown.dataSource = ["me", "friends"]
        dropDown.anchorView = visitBgView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .baseText
        DropDown.appearance().textFont = .systemFont(ofSize: 16)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.visitedButton.setTitle(item, for: .normal)
            self.viewModel.travelModel.friends = index == 1
        }
    }
    
    func subscribe() {
        viewModel.$travelModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] travel in
                guard let self = self else { return }
                self.saveButton.isEnabled = (travel.name.checkValidation() && travel.country.checkValidation() && travel.city.checkValidation() && travel.startDate != nil && travel.endDate != nil && travel.friends != nil)
                self.nameTextField.text = travel.name
                self.countryTextField.text = travel.country
                self.cityTextField.text = travel.city
                self.startDateTextField.text = travel.startDate?.toString()
                self.endDateTextField.text = travel.endDate?.toString()
                if let isFriends = travel.friends, let visited = isFriends ? "friends" : "me" {
                    self.visitedButton.setTitle(visited, for: .normal)
                } else {
                    self.visitedButton.setTitle(nil, for: .normal)
                }
                self.feedBackTextField.text = travel.feedBack
                if let emoji = travel.assessment {
                    self.emojiButtons[emoji].isSelected = true
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func startDateChanged() {
        endDatePicker.minimumDate = startDatePicker.date
        viewModel.travelModel.startDate = startDatePicker.date.stripTime()
    }
    
    @objc func endDateChanged() {
        startDatePicker.maximumDate = endDatePicker.date
        viewModel.travelModel.endDate = endDatePicker.date.stripTime()
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseVisited(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func chooseAssessment(_ sender: UIButton) {
        emojiButtons.forEach({ $0.isSelected = false })
        viewModel.travelModel.assessment = sender.tag
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save {[weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.clickedMenu()
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TravelFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let value = textField.text
        switch textField {
        case nameTextField:
            viewModel.travelModel.name = value
        case countryTextField:
            viewModel.travelModel.country = value
        case cityTextField:
            viewModel.travelModel.city = value
        case feedBackTextField:
            viewModel.travelModel.feedBack = value
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField != startDateTextField && textField != endDateTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension TravelFormViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TravelFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
