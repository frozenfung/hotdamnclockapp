//
//  ChooseSoundViewController.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/23.
//

import UIKit
import AVFoundation

protocol ChooseSoundViewControllerDelegate {
    func didFinishChooseSound(_ controller: ChooseSoundViewController)
}

class ChooseSoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedSound:String?
    let ringtongPlayer = AVPlayer()
    var delegate: ChooseSoundViewControllerDelegate?
    let storeItems = ["Tone Store", "Downlaod All Purchased Tones"]
    let songItems = ["CedarWood Road", "Every Breaking Wave", "Pick a song"]
    let ringtoneItems:[String] = [
        "Arpeggio",
        "Breaking",
        "Canopy",
        "Chalet",
        "Chirp",
        "Daybreak",
        "Departure",
        "Dollop",
        "Journey",
        "Kettle",
        "Mercury",
        "Milky Way",
        "Quad",
        "Radial",
        "Scavenger",
        "Seeding",
        "Shelter",
        "Sprinkles",
        "Steps",
        "Storytime",
        "Tease",
        "Tilt",
        "Unfold",
        "Valley"
    ]

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
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.didFinishChooseSound(self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            40
        } else {
            0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.textLabel?.textColor = .systemGray
            footerView.textLabel?.font = .systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
            footerView.textLabel?.lineBreakMode = .byWordWrapping
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            "This will download all ringtones and alerts purchased using the \"frozenfung@gmail.com\" account."
        } else {
            ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return storeItems.count
        case 2:
            return songItems.count
        case 3:
            return ringtoneItems.count
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "STORE"
        case 2:
            return "SONGS"
        case 3:
            return "RINGTONES"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .systemGray
            headerView.textLabel?.font = .systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
            headerView.textLabel?.lineBreakMode = .byCharWrapping
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HapticsCell", for: indexPath)
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
            cell.setCornerRadius(indexPath.row, rowCount: storeItems.count)
            cell.nameLabel.text = storeItems[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.setCornerRadius(indexPath.row, rowCount: songItems.count)
            cell.nameLabel.text = "       " + songItems[indexPath.row]
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.setCornerRadius(indexPath.row, rowCount: ringtoneItems.count)
            if selectedSound == ringtoneItems[indexPath.row] {
                let str = "\u{2713}    " + ringtoneItems[indexPath.row]
                let myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font :UIFont(name: "Helvetica", size: 17.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.accent, range: NSRange(location:0, length:4))
                cell.nameLabel.attributedText =  myMutableString
            } else {
                cell.nameLabel.text = "       " + ringtoneItems[indexPath.row]
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.nameLabel.text = "       None"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            selectedSound = ringtoneItems[indexPath.row]
            print("here")
            guard let ringtoneUrl = Bundle.main.url(forResource: ringtoneItems[indexPath.row], withExtension: "caf") else { return }
            let playItem = AVPlayerItem(url: ringtoneUrl)
            ringtongPlayer.replaceCurrentItem(with: playItem)
            ringtongPlayer.play()
            ringtongPlayer.seek(to: .zero)
            tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
