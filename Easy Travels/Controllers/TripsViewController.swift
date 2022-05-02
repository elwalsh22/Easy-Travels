//
//  TripsViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var trips: Trips!
    var authUI: FUIAuth!
    var user: TravelUser!
    var items: PackingItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        authUI = FUIAuth.defaultAuthUI()
        
        authUI.delegate = self
        guard let currentUser = authUI.auth?.currentUser else {
            print("Error")
            return
        }
        user = TravelUser(user: currentUser)
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        trips = Trips()
        trips.loadData(user: user) {
            self.trips.tripArray.sort(by:( {$0.departureDate < $1.departureDate}))
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! TripDetailsViewController
            let selectedIndexPathRow = tableView.indexPathForSelectedRow?.row ?? 0
            print(trips.tripArray[selectedIndexPathRow].name)
            destination.trip = trips.tripArray[selectedIndexPathRow]
            destination.user = user
            items = PackingItems()
            items.loadData(user: user, trip: trips.tripArray[selectedIndexPathRow]) {
                destination.items = self.items
            }
            
        } else if segue.identifier == "AddFromTable" {
            let destination = segue.destination as! TripSelectorViewController
            destination.user = user
        }
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.setTitle("Edit", for: .normal)
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.setTitle("Done", for: .normal)
            addButton.isEnabled = false
        }
    }
    
    
    
    
    
    
    
    
}

extension TripsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.tripArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = trips.tripArray[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tripToMove = trips.tripArray[sourceIndexPath.row]
        trips.tripArray.remove(at: sourceIndexPath.row)
        trips.tripArray.insert(tripToMove, at: destinationIndexPath.row)
            
    }
    //gets rid of the delete option
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        .none
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleting: \(trips.tripArray[indexPath.row].name)")
            print("with documentID: \(trips.tripArray[indexPath.row].documentID)")
            print("IndexPath.row is \(indexPath.row)")
            trips.tripArray[indexPath.row].deleteData(user: user,trip: trips.tripArray[indexPath.row]) { success in
                if success {
                    self.trips.tripArray.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
            }


            }
        }
    }
    
}
extension TripsViewController: FUIAuthDelegate {
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
