//
//  PackingItems.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import Foundation
import Firebase

class PackingItems {
    var itemsArray: [PackingItem] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(user: TravelUser, trip: Trip, completed: @escaping () -> ()) {
        guard trip.documentID != "" else {
            return
        }
        db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("items").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.itemsArray = []
            for document in querySnapshot!.documents {
                //pass in dictionary
                let item = PackingItem(dictionary: document.data())
                
                item.documentID = document.documentID
                self.itemsArray.append(item)
            }
            completed()
        }
    }
    

}
