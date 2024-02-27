//
//  AlarmTableViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/10.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    var alarms:[Alarm] = [] {
        didSet {
            toggleNavBarEditButton()
        }
    }
    
    @IBOutlet weak var AddAlarmBut: UIBarButtonItem!
    var selectedAlarm:Alarm?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.backgroundColor = .black
        
        if let savedAlarms = Alarm.loadAlarms() {
            alarms = savedAlarms
            tableView.reloadData()
        }
        
//         for development
//        selectedAlarm = alarms[0]
//        performSegue(withIdentifier: "updateAlarm", sender: AlarmTableViewCell.self)
    }
    
    // MARK: - Table view data source
    @IBAction func unwindToAlarmTableView(_ unwindSegue: UIStoryboardSegue) {
        if let savedAlarms = Alarm.loadAlarms() {
            alarms = savedAlarms
        } else {
            alarms = []
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            "Sleep | Wake Up"
        } else {
            "Other"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.font = .systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
            headerView.textLabel?.lineBreakMode = .byCharWrapping
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Alarm.deleteAlarm(self.alarms[indexPath.row].id)
            self.alarms.remove(at: indexPath.row)
            if alarms.count == 0 {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if alarms.count == 0 {
            1
        } else {
            2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            1
        } else {
            alarms.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            false
        } else {
            true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            90
        } else {
            100
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HealthAlarmTableViewCell", for: indexPath)
            cell.backgroundColor = .black
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
            cell.update(alarms[indexPath.row])
            cell.switcher.id = alarms[indexPath.row].id
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        selectedAlarm = alarms[indexPath.row]
        performSegue(withIdentifier: "updateAlarm", sender: AlarmTableViewCell.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            return
        }
        
        if segue.identifier == "updateAlarm" {
            if let navVC = segue.destination as? UINavigationController,
               let destinationVC = navVC.viewControllers.first as? AddAlarmViewController {
                destinationVC.selectedAlarm = selectedAlarm
            }
        }
    }
    
    func toggleNavBarEditButton() {
        if alarms.count == 0 {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }

    @IBAction func clickSwitcher(_ sender: AlarmSwitcher) {
        guard let id = sender.id else { return }
        let index = alarms.indexOfElement(with: id)
        let alarm = alarms[index]
        Alarm.updateAlarm(alarm.id, newAlarm: Alarm(
            meridium: alarm.meridium,
            time: alarm.time,
            toggle: sender.isOn == true ? Toggle.ON : Toggle.OFF,
            title: alarm.title,
            days: alarm.days,
            sound: alarm.sound
        ))
        
        if let savedAlarms = Alarm.loadAlarms() {
            alarms = savedAlarms
            tableView.reloadData()
        }
    }
    
    @IBAction func removeScheduleNotifications(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    @IBAction func showAllPendingRequest(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests() { ns in
            print("----------show all pending requests----------")
            for n in ns {
                print(n)
            }
        }
    }
}

extension Array where Element: Identifiable {
    func indexOfElement(with id: Element.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
