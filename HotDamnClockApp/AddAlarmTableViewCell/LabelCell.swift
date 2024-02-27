//
//  LabelCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/14.
//

import UIKit

protocol LabelCellDelegate {
    func updateAlarmTitle(_ cell: LabelCell)
}

class LabelCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var alarmTitle: UITextField!
    var delegate: LabelCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .alarmConfigTableCellBg
        
        textLabel?.text = "Label"
        textLabel?.textColor = .white
        
        let myMutableString = NSMutableAttributedString(string: "Alarm", attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSRange(location:0, length:5))
        
        alarmTitle.delegate = self
        alarmTitle.attributedPlaceholder = myMutableString
        alarmTitle.backgroundColor = .alarmConfigTableCellBg
        alarmTitle.textColor = .lightGray
        alarmTitle.borderStyle = .none
        alarmTitle.textAlignment = NSTextAlignment.right
        alarmTitle.clearButtonMode = .whileEditing
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.delegate?.updateAlarmTitle(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
}
