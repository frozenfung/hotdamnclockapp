//
//  CityTableViewCell.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/5.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var HRS: UILabel!
    @IBOutlet weak var PMAM: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        PMAM.textColor = .white
        cityName.textColor = .white
        cityTime.textColor = .white
        HRS.textColor = .gray
        
        self.selectionStyle = .none
        self.showsReorderControl = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with clock: Clock, isEditing: Bool) {
        let result = calculateCityTimeAndPMAM(clock.city)
        let resultCityTime = result.split(separator: " ").first!
        let resultPMAM = result.split(separator: " ").last!
        
        if isEditing {
            cityTime.isHidden = true
            PMAM.isHidden = true
        } else {
            cityTime.isHidden = false
            PMAM.isHidden = false
            cityTime.text = String(resultCityTime)
            PMAM.text = String(resultPMAM)
        }
        cityName.text = String(showCityOnly(identifier: clock.city))
        
        HRS.text = "Today, \(calculateHRS(clock.city))HRS"
    }
    
    func showCityOnly(identifier: String) -> String {
        return identifier.split(separator: "/").last!.replacingOccurrences(of: "_", with: " ")
    }
    
    func calculateCityTimeAndPMAM(_ identifier: String) -> String {
        let tz = TimeZone(identifier: identifier)
        guard let seconds = tz?.secondsFromGMT() else { return "Timezone not found" }

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: seconds)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    func calculateHRS(_ identifier: String) -> Int {
        let tz = TimeZone(identifier: identifier)
        guard let seconds = tz?.secondsFromGMT() else { return 0 }
        let taipeiSecondsFromGMT = 3600 * 8
        return (seconds - taipeiSecondsFromGMT) / 3600
    }
}
