//
//  BaseSwitch.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//


import UIKit

class BaseSwitch: UISwitch {
    override var isOn: Bool {
        didSet {
//            self.thumbTintColor = isOn ? .baseGreen : .baseOrange
        }
    }
}
