//
//  WelcomeViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var trips: Trips!
    var user: TravelUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        trips = Trips()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTripSelector" {
            let destination = segue.destination as! TripSelectorViewController
            destination.user = self.user
            print("welcome controller user is \(user.documentID ?? "error")")
        }
    }
    
   
    
    
    }
    


