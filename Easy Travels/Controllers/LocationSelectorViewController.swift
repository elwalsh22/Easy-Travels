//
//  DateSelectorViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class LocationSelectorViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var location: GMSPlace!
    var trip: Trip!
    var user: TravelUser!
    let regionDistance: CLLocationDegrees = 4000.0
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if trip == nil {
            trip = Trip()
        }
        if user == nil {

        }
        locationNameLabel.text = ""
        setupMapView()
        updateUserInterface()
        
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
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPackingList" {
            let destination = segue.destination as! PackingListViewController
            destination.trip = trip
            destination.user = user
        }
    }
    
    @IBAction func packingButtonPressed(_ sender: UIButton) {
        print("before the save \(trip.documentID)")
        trip.saveData(user: user) { success in
            if success {
                self.performSegue(withIdentifier: "ShowPackingList", sender: sender)
                print("LocationSaved")
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "For some reason the data did not save to the cloud.")
            }
        }
        
    }
    
    
    
}

extension LocationSelectorViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        //TODO: Create a new location object that stores the place name, latitude, longitude of coordinate.then append to the data? add to data somewhere. reload data if in table view?
        locationNameLabel.text = place.name ?? ""
        trip.address = place.formattedAddress ?? "Unknown Address"
        trip.coordinate = place.coordinate
        updateUserInterface()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension LocationSelectorViewController: CLLocationManagerDelegate {
   
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




