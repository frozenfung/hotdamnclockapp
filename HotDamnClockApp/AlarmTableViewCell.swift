//
//  AlarmTableViewCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/10.
//

import UIKit

class AlarmSwitcher: UISwitch {
    var id: Alarm.ID?
}

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var alarmTitle: UILabel!
    @IBOutlet weak var switcher: AlarmSwitcher!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        time.textColor = .lightGray
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(_ alarm: Alarm) {
        let str = alarm.time + alarm.meridium
        let myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 56, weight: UIFont.Weight.light)])
        if alarm.time.count > 4 {
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.light), range: NSRange(location:5, length:2))
        } else {
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.light), range: NSRange(location:4, length:2))
        }
        time.attributedText = myMutableString
        alarmTitle.text = alarm.title
        if alarm.toggle == .ON {
            switcher.isOn = true
            time.textColor = .white
            alarmTitle.textColor = .white
        } else {
            switcher.isOn = false
            time.textColor = .lightGray
            alarmTitle.textColor = .lightGray
        }
    }
}
