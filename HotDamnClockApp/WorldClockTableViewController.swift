//
//  WorldClockTableViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/9.
//

import UIKit

class WorldClockTableViewController: UITableViewController {
    var cities:[Clock] = [] {
        didSet {
            toggleNavBarEditButton()
            setNeedsUpdateContentUnavailableConfiguration()
        }
    }

    @IBOutlet weak var AddNewCityClock: UIBarButtonItem!
    @IBAction func unwindToWorldClockTableView(_ unwindSegue: UIStoryboardSegue) {
        if let worldClocks = Clock.loadWorldClocks() {
            cities = worldClocks
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.backgroundColor = .black
        
        // initialize cities from UserDefault
        if let worldClocks = Clock.loadWorldClocks() {
            cities = worldClocks
            tableView.reloadData()
        }
        
        toggleNavBarEditButton()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                let clock = cities[indexPath.row]
                if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
                    cell.update(with: clock, isEditing: isEditing)
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        cell.update(with: Clock(city: cities[indexPath.row].city), isEditing: false)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Clock.removeWorldClocks(removedClock: self.cities[indexPath.row].city)
            self.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCity = cities.remove(at: fromIndexPath.row)
        cities.insert(movedCity, at: to.row)
    }
    
    func toggleNavBarEditButton() {
        if cities.count == 0 {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        var config: UIContentUnavailableConfiguration?
        if cities.count == 0 {
          var empty = UIContentUnavailableConfiguration.empty()
          empty.background.backgroundColor = .black
          empty.text = "No World Clocks"
          empty.textProperties.color = .lightGray
          config = empty
        }
        contentUnavailableConfiguration = config
    }
}
