//
//  Trips.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import Foundation
import Firebase

class Trips {
    var tripArray: [Trip] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(user: TravelUser, completed: @escaping () -> ()) {
        guard user.documentID != "" else {
            return
        }
        db.collection("users").document(user.documentID).collection("trips").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.tripArray = []
            for document in querySnapshot!.documents {
                //pass in dictionary
                let trip = Trip(dictionary: document.data())
                
                trip.documentID = document.documentID
                self.tripArray.append(trip)
            }
            completed()
        }
    }
}
