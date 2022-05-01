//
//  PackingItem.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import Foundation


import Foundation
import Firebase
import FirebaseFirestore


class PackingItem {
    var itemName: String
    var quantity: Int
    var isPacked: Bool
    var itemUserID: String
    var documentID: String
    var dictionary: [String: Any] {
        
        return ["itemName" : itemName , "quantity": quantity, "isPacked": isPacked, "itemUserID": itemUserID]
    }
    init(itemName: String, quantity: Int, isPacked: Bool,  itemUserID: String, documentID: String){
        self.itemName = itemName
        self.quantity = quantity
        self.isPacked = isPacked
        self.itemUserID = itemUserID
        self.documentID = documentID
        
    }
    convenience init(dictionary: [String: Any]) {
        let itemName = dictionary["itemName"] as! String? ?? ""
        let quantity = dictionary["quantity"] as! Int? ?? 0
        let isPacked = dictionary["isPacked"] as! Bool? ?? false
        let itemUserID = dictionary["itemUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        self.init(itemName: itemName, quantity: quantity, isPacked: isPacked, itemUserID: itemUserID, documentID: documentID)
        
    }
    
    convenience init() {
        let itemUserID = Auth.auth().currentUser?.uid ?? ""

        self.init(itemName: "",  quantity: 0, isPacked: false, itemUserID: itemUserID , documentID: "")
    }
    
    func saveData(user: TravelUser, trip: Trip, completed: @escaping (Bool) -> ()) {
        
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("items").addDocument(data: dataToSave) {
                (error) in guard error == nil else {
                    print("😡Error adding document \(error!.localizedDescription)")
                    return completed(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)")
                
            }
            
            
        } else {
            let ref = db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("items").document(self.documentID)
            ref.setData(dataToSave) {
                (error) in guard error == nil else {
                    print("😡Error updating document \(error!.localizedDescription)")
                    return completed(false)
                }
                print("Updated Document: \(self.documentID)")
                
            }
        }
        
    }
    
    
    func deleteData(user: TravelUser, trip: Trip, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("items").document(documentID).delete() { error in
            if let error = error {
                print("Error: deleting review \(self.documentID)")
                completion(false)
            } else {
                print("successfully deleted \(self.documentID)")
                completion(true)
            }
        }
    }

    
}
