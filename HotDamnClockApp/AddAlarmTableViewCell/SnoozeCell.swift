//
//  SnoozeCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/14.
//

import UIKit

class SnoozeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textLabel?.text = "Snooze"
        backgroundColor = .alarmConfigTableCellBg
        textLabel?.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        // Configure the view for the selected state
    }

}
