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

    @IBOutlet weak var locationNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
        // Display the autocomplete view controller.
            present(autocompleteController, animated: true, completion: nil)
    }
    
    
}

extension LocationSelectorViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
      //TODO: Create a new location object that stores the place name, latitude, longitude of coordinate.then append to the data? add to data somewhere. reload data if in table view?
      locationNameLabel.text = place.name ?? "Unknown"

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
