//
//  BasicCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/25.
//

import UIKit

class BasicCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCornerRadius(_ row: Int, rowCount: Int) {
        if (row == 0) {
            layer.cornerRadius = 10
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if (row == rowCount - 1) {
            layer.cornerRadius = 10
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            layer.cornerRadius = 0
        }
    }
    
    func addCustomDisclosureIndicator(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right",
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}
