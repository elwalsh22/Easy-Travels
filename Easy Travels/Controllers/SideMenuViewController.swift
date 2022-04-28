//
//  SideMenuViewController.swift
//  Easy Travels
//  Attribution: johncodeos.com tutorial on side menus
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import SDWebImage

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {

    var authUI: FUIAuth!
    
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
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        guard let currentUser = authUI.auth?.currentUser else {
            print("Error")
            return
        }
      
        nameLabel.text = currentUser.displayName
        guard let url =  currentUser.photoURL else {
            self.imageView.image = UIImage(systemName: "person.crop.circle")
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))

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
    

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        signOut()
        performSegue(withIdentifier: "ReturnToLogin", sender: sender)
        
    }
    
    func signOut() {
        do {
            try authUI!.signOut()
        } catch {
            print("😡 ERROR: couldn't sign out")
//            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }


}
    
    

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

extension SideMenuViewController: FUIAuthDelegate {
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let marginInsets: CGFloat = 16.0 // amount to indent UIImageView on each side
        let topSafeArea = self.view.safeAreaInsets.top

        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)

        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        loginViewController.view.subviews[0].backgroundColor = UIColor.clear
        loginViewController.view.subviews[0].subviews[0].backgroundColor = UIColor.clear

        // Create a frame for a UIImageView to hold our logo
        let x = marginInsets
        let y = marginInsets + topSafeArea
        let width = self.view.frame.width - (marginInsets * 2)
        //        let height = loginViewController.view.subviews[0].frame.height - (topSafeArea) - (marginInsets * 2)
        let height = UIScreen.main.bounds.height - (topSafeArea) - (marginInsets * 2)

        let logoFrame = CGRect(x: x, y: y, width: width, height: height)

        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
    
}
