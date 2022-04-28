//
//  TripDetailsViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class TripDetailsViewController: UIViewController {
    
    var trip: Trip!
    var items: PackingItems!
    var users: TravelUsers!
    
    var locations: Locations!
    var friends: Friends!
    
    var nSelectedSegmentIndex : Int = 1
    
    let regionDistance: CLLocationDegrees = 2000.0
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tripNameLabel.text = trip.name
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        navigationController?.setToolbarHidden(true, animated: false)
        
        setupMapView()
        updateUserInterface()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        locations = Locations()
        friends = Friends()
        users = TravelUsers()
        friends.loadData {
            self.itemsTableView.reloadData()
        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.nSelectedSegmentIndex = 1
        }
        else if sender.selectedSegmentIndex == 1 {
            self.nSelectedSegmentIndex = 2
        } else {
            self.nSelectedSegmentIndex = 3
        }
        self.itemsTableView.reloadData()
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if self.nSelectedSegmentIndex == 1 {
            performSegue(withIdentifier: "AddItemFromTripDetails", sender: sender)
            
        } else if self.nSelectedSegmentIndex == 3 {
                performSegue(withIdentifier: "AddFriend", sender: sender)
        
        }
        
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion(center: trip.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
    }
    func updateUserInterface() {
        updateMap()
        
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(trip)
        mapView.setCenter(trip.coordinate, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "AddItemFromTripDetails":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! PackingDetailViewController
            destination.trip = trip
            destination.items = items
            
        case "AddFriend":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! AddFriendViewController
            destination.users = users
        default:
            print("error")
            
            
        }
        
    }
}




extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nSelectedSegmentIndex == 1 {
            return items.itemsArray.count
            
        }
        else if nSelectedSegmentIndex == 2 {
            return locations.locationsArray.count
        } else { return friends.userArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "PackingCell", for: indexPath) as! TripDetailsTableViewCell
        if nSelectedSegmentIndex == 1 {
            cell.cellLabel?.text = items.itemsArray[indexPath.row].itemName
        }
        else if nSelectedSegmentIndex == 2{
            cell.cellLabel?.text = locations.locationsArray[indexPath.row].locationName
        } else {
            cell.cellLabel?.text = friends.userArray[indexPath.row].displayName
        }
        
        
        return cell
    }
    
    
}


extension TripDetailsViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        
        //Creating a locationmanager will automatically check authorization.b
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Checking authentication status")
        handleAuthenticalStatus(status: status)
    }
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: UNKNOWN case of status in handleAuthenticalStatus \(status)")
        }
        
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert
        )
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("updating location")
        let currentLocation = locations.last ?? CLLocation()
        print("current location is \(currentLocation.coordinate.longitude) \(currentLocation.coordinate.latitude)")
        var name = ""
        var address = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print("ERROR retreiving place. Error Code: \(error!.localizedDescription)")
            }
            if placemarks != nil {
                //get the first placemark
                let placemark = placemarks?.last
                // assign placemark to locationName
                name = placemark?.name ?? "Name Unknown"
                if let postalAddress = placemark?.postalAddress {
                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                }
            } else {
                print("ERROR retreiving placemark . Error Code: \(error?.localizedDescription)")
            }
            
            //            if self.spot.name == "" && self.spot.address == "" {
            //                self.spot.name = name
            //                self.spot.address = address
            //                self.spot.coordinate = currentLocation.coordinate
            //            }
            self.mapView.userLocation.title = name
            self.mapView.userLocation.subtitle = address.replacingOccurrences(of: "\n", with: ", ")
            
            
            self.updateUserInterface()
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
    
}
