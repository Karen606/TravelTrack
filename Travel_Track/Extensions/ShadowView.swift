//
//  ShadowView.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//


import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        addShadow()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         addShadow()
     }
}