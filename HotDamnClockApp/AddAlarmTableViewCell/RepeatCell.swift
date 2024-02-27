//
//  RepeatCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/14.
//

import UIKit

class RepeatCell: BasicCell {
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textLabel?.text = "Repeat"
        backgroundColor = .alarmConfigTableCellBg
        textLabel?.textColor = .white
        addCustomDisclosureIndicator(with: .lightGray)
        
        labelText.text = "Never"
        labelText.textColor = .lightGray
        labelText.textAlignment = NSTextAlignment.right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        // Configure the view for the selected state
    }

}
