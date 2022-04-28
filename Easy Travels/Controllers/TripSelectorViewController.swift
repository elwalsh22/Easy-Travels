//
//  TripSelectorViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import GooglePlaces

class TripSelectorViewController: UIViewController {
    
    var canSegue = false
    var trip: Trip!

    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var returnDatePicker: UIDatePicker!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        if trip == nil {
            trip = Trip()
            
        } else {
            tripNameTextField.text = trip.name
            departureDatePicker.date = trip.departureDate
            returnDatePicker.date = trip.returnDate
        }
    
    }
    
    @IBAction func tripNameChanged(_ sender: UITextField) {
        let noSpaces = tripNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            canSegue = true
        } else {
            errorLabel.text = "please give your trip a name to continue"
        }
        
    }
    @IBAction func departureChanged(_ sender: UIDatePicker) {
        print("departure date: \(departureDatePicker.date)")
        
    }
    
              
    @IBAction func returnChanged(_ sender: UIDatePicker) {
        
        print("return date: \(returnDatePicker.date)")
        if returnDatePicker.date <= departureDatePicker.date {
            canSegue = false
            errorLabel.text = "please give your trip a name to continue"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLocationSelector" {
            let destination = segue.destination as! LocationSelectorViewController
            print("in the prepare for segue, the trip doc id is \(self.trip.documentID) .")
            destination.trip = self.trip
        }
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if returnDatePicker.date > departureDatePicker.date {
            canSegue = true
        }
        trip.name = tripNameTextField.text!
        if canSegue {
            trip.saveData { success in
                if success {
                    self.errorLabel.isHidden = false
                    self.performSegue(withIdentifier: "ShowLocationSelector", sender: sender)
                } else {
                    print("error: tried to save a new user but failed")
                }
            }
           
        }
        else {
            errorLabel.isHidden = false
        }
    }
    
}
