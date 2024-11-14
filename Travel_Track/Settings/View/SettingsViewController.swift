//
//  SettingsViewController.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import UIKit
import TTSwitch

class SettingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var settingsButton: [UIButton]!
    @IBOutlet weak var interfaceModeSwitch: BaseSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interfaceModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        setNaviagtionMenuButton()
        titleLabel.font = .architects(size: 20)
        settingsButton.forEach({ $0.titleLabel?.font = .architects(size: 26)})
        interfaceModeSwitch.backgroundColor = .switch
        interfaceModeSwitch.thumbImage = .switchOff
        interfaceModeSwitch.thumbImageView.backgroundColor = .baseWhite
        interfaceModeSwitch.thumbImageView.layer.cornerRadius = interfaceModeSwitch.thumbImageView.frame.height / 2
        interfaceModeSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        interfaceModeSwitch.thumbInsetX = 4
        interfaceModeSwitch.thumbOffsetY = 4
    }
    
    @IBAction func chooseInterfaceMode(_ sender: BaseSwitch) {
        interfaceModeSwitch.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}

class BaseSwitch: TTSwitch {
    override var isOn: Bool {
        didSet {
            thumbImage = isOn ? .switchOn : .switchOff
        }
    }
}
