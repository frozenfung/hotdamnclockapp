//
//  SongCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/23.
//

import UIKit

class SongCell: BasicCell {
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgColorView = UIView()
        backgroundColor = .alarmConfigTableCellSelectedBg
        selectedBackgroundView = bgColorView
        nameLabel.textColor = .white
        backgroundColor = .alarmConfigTableCellBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
