//
//  DeleteCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/20.
//

import UIKit

class DeleteCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundColor = .alarmConfigTableCellBg
        textLabel?.textColor = .white
        
        labelText.text = "Delete alarm"
        labelText.textColor = .red
        labelText.textAlignment = NSTextAlignment.center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }

}
