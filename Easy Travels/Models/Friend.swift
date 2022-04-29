//
//  Friend.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/28/22.
//

import Foundation
import Firebase

class Friend: TravelUser {
    
   
    
    convenience init(user: User) {
        let email = user.email ?? ""
        let displayName = user.displayName ?? ""
        let photoURL = (user.photoURL != nil ? "\(user.photoURL!)" : "")
        
        self.init(email: email, displayName: displayName, photoURL: photoURL, userSince: Date(), documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        let timeIntervalDate = dictionary["userSince"] as! TimeInterval? ??  TimeInterval()
        let userSince = Date(timeIntervalSince1970: timeIntervalDate)
        self.init(email: email, displayName: displayName, photoURL: photoURL, userSince: userSince, documentID: "")
        
        
    }
    
    func saveIfNewFriend(user: TravelUser, trip: Trip, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("friends").document(documentID)
        userRef.getDocument { document, error in
            guard error == nil else {
                print("Error cannout access document")
                return completion(false)
        }
            guard document?.exists == false else {
                print("the document for user \(self.documentID) already exists. no need to recreate it")
                return completion(true)
            }
            //create new document
            
            let dataToSave: [String: Any] = self.dictionary
            db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("friends").document(self.documentID).setData(dataToSave) { (error) in
                guard error == nil else {
                    print("Error \(error!.localizedDescription)")
                    return completion(false)
                }
                return completion(true)
            }
        }
    }
}

