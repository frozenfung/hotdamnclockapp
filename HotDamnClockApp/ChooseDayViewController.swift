//
//  ChooseDayViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/18.
//

import UIKit

protocol ChooseDayViewControllerDelegate {
    func didFinishChooseDay(_ controller: ChooseDayViewController)
}

class ChooseDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedAlarm:Alarm?
    var checkedDays:[String] = []
    var delegate: ChooseDayViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .chooseCityBackground

        view.backgroundColor = .chooseCityBackground
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .chooseCityBackground
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkCellWithSelectedAlarm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.didFinishChooseDay(self)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggle checkmark on and off
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            checkedDays = checkedDays.filter { $0 != Days[indexPath.row]}
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            checkedDays.append(Days[indexPath.row])
        }
        
        //add animation so cell does not stay selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayViewCell", for: indexPath)
        
        // first cell
        if (indexPath.row == 0) {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        // last cell
        if (indexPath.row == 6) {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }

        let bgColorView = UIView()
        bgColorView.backgroundColor = .alarmConfigTableCellSelectedBg
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.text = "Every \(String(describing: Days[indexPath.row]))"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .alarmConfigTableCellBg
        cell.accessoryType = .none
        return cell
    }
    
    func checkCellWithSelectedAlarm() {
        for cd in checkedDays {
            Days.enumerated().forEach {
                if $0.element == cd {
                    tableView.cellForRow(at: [0, $0.offset])?.accessoryType = .checkmark
                }
            }
        }
    }
}
