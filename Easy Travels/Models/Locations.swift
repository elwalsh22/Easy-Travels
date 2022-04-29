//
//  Locations.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/27/22.
//

import Foundation
import Firebase

class Locations {
    var locationsArray: [Location] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(user: TravelUser, trip: Trip, completed: @escaping () -> ()) {
        guard trip.documentID != "" && user.documentID != "" else {
            return
        }
        
        db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("locations").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.locationsArray = []
            for document in querySnapshot!.documents {
                //pass in dictionary
                let location = Location(dictionary: document.data())
                
                location.documentID = document.documentID
                self.locationsArray.append(location)
            }
            completed()
        }
    }
    

}
