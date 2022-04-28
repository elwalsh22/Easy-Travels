//
//  Friends.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/28/22.
//

import Foundation
import Firebase
class Friends: TravelUsers {
   
    
    func loadData(user: TravelUser, completed: @escaping () -> ()) {
        db.collection("users").document(user.documentID).collection("friends").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = []
            for document in querySnapshot!.documents {
                //pass in dictionary
                let friend = Friend(dictionary: document.data())
                
                friend.documentID = document.documentID
                self.userArray.append(friend)
                
            }
            completed()
        }
    }
}
