//
//  SideMenuViewController.swift
//  Easy Travels
//  Attribution: johncodeos.com tutorial on side menus
//  Created by Ella Walsh on 4/24/22.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    var menu: [SideMenuModel] = [
            SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
            SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Users"),
            SideMenuModel(icon: UIImage(systemName: "airplane")!, title: "Trips"),
           
        ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
                self.sideMenuTableView.delegate = self
                self.sideMenuTableView.dataSource = self
                self.sideMenuTableView.backgroundColor = #colorLiteral(red: 0.2612557411, green: 0.3280342221, blue: 0.2743004858, alpha: 1)
                self.sideMenuTableView.separatorStyle = .none

                // Set Highlighted Cell
                DispatchQueue.main.async {
                    let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
                    self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
                }
        // Register TableView Cell
        self.sideMenuTableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)

                // Update TableView with the data
                self.sideMenuTableView.reloadData()

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


// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.2612557411, green: 0.3280342221, blue: 0.2743004858, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(indexPath.row)
        // ...
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
