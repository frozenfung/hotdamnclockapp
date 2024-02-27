//
//  SoundCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/14.
//

import UIKit

class SoundCell: BasicCell {
    @IBOutlet weak var labelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textLabel?.text = "Sound"
        backgroundColor = .alarmConfigTableCellBg
        textLabel?.textColor = .white
        addCustomDisclosureIndicator(with: .lightGray)
        
        labelText.text = "Radial"
        labelText.textColor = .lightGray
        labelText.textAlignment = NSTextAlignment.right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }

}
