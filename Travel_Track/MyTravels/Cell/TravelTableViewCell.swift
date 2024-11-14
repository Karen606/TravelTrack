//
//  TravelTableViewCell.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import UIKit

protocol TravelTableViewCellDelegate: AnyObject {
    func remove(id: UUID)
}

class TravelTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var feedBackLabel: UILabel!
    @IBOutlet weak var bgView: ShadowView!
    private var id: UUID?
    weak var delegate: TravelTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        countryLabel.font = .architects(size: 16)
        dateLabel.font = .architects(size: 16)
        feedBackLabel.font = .architects(size: 8)
        bgView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        emojiImageView.image = nil
        id = nil
    }
    
    func configure(travel: TravelModel) {
        self.id = travel.id
        countryLabel.text = "\(travel.city ?? ""), \(travel.country ?? "")"
        dateLabel.text = travel.startDate?.toString()
        if let emoji = travel.assessment {
            emojiImageView.image = UIImage(named: "emoji\(emoji)")
        }
        feedBackLabel.text = travel.feedBack
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        guard let id = id else { return }
        delegate?.remove(id: id)
    }
}
