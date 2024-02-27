//
//  AddAlarmViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/10.
//

import UIKit

enum AlarmComponent: Int {
    case hour = 0
    case minute = 1
    case meridium = 2
}

class AddAlarmViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ChooseDayViewControllerDelegate, LabelCellDelegate, ChooseSoundViewControllerDelegate {

    var selectedAlarm:Alarm?
    var checkedDays:[String] = []
    var selectedSound:String = "Departure"
    var alarmTitle:String?
    
    @IBOutlet weak var configTableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var timePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .chooseCityBackground
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        configTableView.backgroundColor = .chooseCityBackground
        configTableView.isScrollEnabled = false
        
        if let sa = selectedAlarm {
            checkedDays = sa.days
            alarmTitle = sa.title
            selectedSound = sa.sound
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 3600 * 8)
        formatter.dateFormat = "h/mm/a"
        
        let result = formatter.string(from: Date()).split(separator: "/")
        if let sa = selectedAlarm {
            timePicker.selectRow(Int(sa.time.split(separator: ":")[0])! - 1, inComponent: 0, animated: true)
            timePicker.selectRow(Int(sa.time.split(separator: ":")[1])! - 1, inComponent: 1, animated: true)
            if (sa.meridium == "AM") {
                timePicker.selectRow(0, inComponent: 2, animated: true)
            } else {
                timePicker.selectRow(1, inComponent: 2, animated: true)
            }
        } else {
            timePicker.selectRow(Int(result[0])! - 1, inComponent: 0, animated: true)
            timePicker.selectRow(Int(result[1])! - 1, inComponent: 1, animated: true)
            if (String(result[2]) == "AM") {
                timePicker.selectRow(0, inComponent: 2, animated: true)
            } else {
                timePicker.selectRow(1, inComponent: 2, animated: true)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case AlarmComponent.hour.rawValue:
            return 60
        case AlarmComponent.minute.rawValue:
            return 50
        case AlarmComponent.meridium.rawValue:
            return 70
        default:
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case AlarmComponent.hour.rawValue:
            return String(row + 1)
        case AlarmComponent.minute.rawValue:
            if row < 9 {
                return "0\(String(row + 1))"
            } else {
                return String(row + 1)
            }
        case AlarmComponent.meridium.rawValue:
            if row == 0 {
                return "AM"
            } else {
                return "PM"
            }
        default:
            return "Error!"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case AlarmComponent.hour.rawValue:
            return 12
        case AlarmComponent.minute.rawValue:
            return 59
        case AlarmComponent.meridium.rawValue:
            return 2
        default:
            return 0
        }
    }
    
    // tableview func
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedAlarm != nil {
            2
        } else {
            1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            4
        } else {
            1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCell", for: indexPath) as! RepeatCell
                if checkedDays != [] {
                    if checkedDays.count == 1 {
                        cell.labelText.text = "Every \(checkedDays[0])"
                    } else if checkedDays.count < 7  {
                        cell.labelText.text = checkedDays.map({$0.prefix(3)}).joined(separator:", ")
                    } else {
                        cell.labelText.text = "Every day"
                    }
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
                cell.delegate = self
                if let title = selectedAlarm?.title {
                    cell.alarmTitle.text = title
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath) as! SoundCell
                cell.labelText.text = selectedSound
                return cell
            default:
                return tableView.dequeueReusableCell(withIdentifier: "SnoozeCell", for: indexPath)
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let controller = storyboard?.instantiateViewController(withIdentifier: "\(ChooseDayViewController.self)") as? ChooseDayViewController else { return }
                controller.title = "Repeat"
                controller.delegate = self
                controller.checkedDays = checkedDays
                self.view.endEditing(true)
                navigationController?.pushViewController(controller, animated: true)
            case 2:
                guard let controller = storyboard?.instantiateViewController(withIdentifier: "\(ChooseSoundViewController.self)") as? ChooseSoundViewController else { return }
                controller.title = "Sound"
                controller.delegate = self
                controller.selectedSound = selectedSound
                self.view.endEditing(true)
                navigationController?.pushViewController(controller, animated: true)
            default:
                return
            }
        } else {
            Alarm.deleteAlarm(selectedAlarm!.id)
            performSegue(withIdentifier: "complishAddNewAlarm", sender: self)
        }
    }
    
    @IBAction func clickSaveBut(_ sender: Any) {
        let hour = timePicker.selectedRow(inComponent: 0) + 1
        let minutes = timePicker.selectedRow(inComponent: 1) + 1
        var meridium:String
        let meridiumIndex = timePicker.selectedRow(inComponent: 2)
        
        var time:String
        if minutes < 10 {
            time = "\(hour):0\(minutes)"
        } else {
            time = "\(hour):\(minutes)"
        }
        
        if meridiumIndex == 0 {
            meridium = "AM"
        } else {
            meridium = "PM"
        }
        
        if let sa = selectedAlarm {
            Alarm.updateAlarm(sa.id, newAlarm: Alarm(
                meridium: meridium,
                time: time,
                toggle: Toggle.ON,
                title: alarmTitle ?? "Alarm",
                days: checkedDays,
                sound: selectedSound
            ))
        } else {
            Alarm.saveAlarms(Alarm(
                meridium: meridium,
                time: time,
                toggle: Toggle.ON,
                title: alarmTitle ?? "Alarm",
                days: checkedDays,
                sound: selectedSound
            ))
        }
        performSegue(withIdentifier: "complishAddNewAlarm", sender: self)
    }
    
    func updateAlarmTitle(_ cell: LabelCell) {
        alarmTitle = cell.alarmTitle.text ?? "Alarm"
    }
    
    func didFinishChooseDay(_ controller: ChooseDayViewController) {
        checkedDays = controller.checkedDays
        configTableView.reloadData()
    }
    
    func didFinishChooseSound(_ controller: ChooseSoundViewController) {
        selectedSound = controller.selectedSound ?? "Departure"
        configTableView.reloadData()
    }
    
    @IBAction func clickCancelBut(_ sender: Any) {
        dismiss(animated: true)
    }
}
