//
//  TravelUsers.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import Foundation
import Firebase

class TravelUsers {
    var userArray: [TravelUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = []
            for document in querySnapshot!.documents {
                //pass in dictionary
                let travelUser = TravelUser(dictionary: document.data())
                
                travelUser.documentID = document.documentID
                self.userArray.append(travelUser)
                
            }
            completed()
        }
    }
}
