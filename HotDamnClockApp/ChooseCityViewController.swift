//
//  ChooseCityViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/6.
//

import UIKit

class ChooseCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var cityTableView: UITableView!
    
    lazy var dataset = TimeZone.knownTimeZoneIdentifiers
    lazy var filteredCities = dataset

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCityTableViewCell", for: indexPath)
        cell.backgroundColor = .chooseCityBackground
        cell.textLabel?.text = String(dataset[indexPath.row].split(separator: "/").last!).replacingOccurrences(of: "_", with: " ")
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Clock.saveWorldClocks(savedClock: Clock(city: String(dataset[indexPath.row])))
        performSegue(withIdentifier: "complishAddNewClock", sender: self)
    }
}

extension ChooseCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dataset = TimeZone.knownTimeZoneIdentifiers
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false  {
            filteredCities = dataset.filter({ c in
                c.split(separator: "/").last!.localizedStandardContains(searchText)
            })
            dataset = filteredCities
        }
        
        cityTableView.reloadData()
    }
}

extension ChooseCityViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCities = TimeZone.knownTimeZoneIdentifiers
        self.cityTableView.reloadData()
    }
}
