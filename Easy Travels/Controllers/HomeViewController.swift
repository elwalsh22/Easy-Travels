//
//  HomeViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI



class HomeViewController: UIViewController {
    
    var user: TravelUser!
    var trips: Trips!
    var authUI: FUIAuth!
    var trip: Trip!
    var items: PackingItems!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var daysLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .short
        
        guard let currentUser = authUI.auth?.currentUser else {
            print("Error")
            return
        }
        user = TravelUser(user: currentUser)
        
        tableView.delegate = self
        tableView.dataSource = self
        welcomeLabel.text = "Welcome \(currentUser.displayName ?? "")"
        
        if trips == nil {
        trips = Trips()
        }
        if trip == nil {
            trip = Trip()
        }
        if items == nil {
            items = PackingItems()
        }
        trips.loadData(user: user) {
            self.tableView.reloadData()
            
            if self.trips.tripArray.count == 0 {
                self.daysLabel.isHidden = true
                self.daysUntilLabel.isHidden = true
                self.locationLabel.text = "No Upcoming Trips"
            } else {
                let delta = self.trips.tripArray[0].departureDate.timeIntervalSince(Date())
            self.daysLabel.text = "\(formatter.string(from: delta) ?? "")"

            self.locationLabel.text = self.trips.tripArray[0].name
            }
            
        }
        
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTripDetails" {
            let destination = segue.destination as! TripDetailsViewController
            let selectedIndexPathRow = tableView.indexPathForSelectedRow?.row ?? 0
            print(trips.tripArray[selectedIndexPathRow].name)
            destination.trip = trips.tripArray[selectedIndexPathRow]
            destination.user = user
//            items = PackingItems()
//            items.loadData(user: user, trip: trips.tripArray[selectedIndexPathRow]) {
//                destination.items = self.items
//            }
            
        }
        else if segue.identifier == "AddTrip" {
            let destination = segue.destination as! TripSelectorViewController
            destination.user = user
        }
    }
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.tripArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .spellOut
        cell.textLabel?.text = trips.tripArray[indexPath.row].name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        print(dateFormatter.string(from: trips.tripArray[indexPath.row].departureDate))
        print(dateFormatter.string(from: Date()))
        
        let delta = trips.tripArray[indexPath.row].departureDate.timeIntervalSince(Date())
        cell.detailTextLabel?.text = "in \(formatter.string(from: delta) ?? "")"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    
}


extension HomeViewController: FUIAuthDelegate {
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
