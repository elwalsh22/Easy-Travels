//
//  Location.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/27/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import MapKit


class Location {
    var locationName: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["locationName" : locationName ,"address": address, "latitude": latitude, "longitude": longitude]
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    var title: String? {
        return locationName
    }
    var subtitle: String? {
        return address
    }
    
    init(locationName: String, address: String, coordinate: CLLocationCoordinate2D, documentID: String){
        self.locationName = locationName
        self.address = address
        self.coordinate = coordinate
        self.documentID = documentID
        
    }
    convenience init(dictionary: [String: Any]) {
        let locationName = dictionary["locationName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        self.init(locationName: locationName, address: address, coordinate: coordinate, documentID: documentID)
        
    }
    

    
    func saveData(user: TravelUser, trip: Trip, completed: @escaping (Bool) -> ()) {
        
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("locations").addDocument(data: dataToSave) {
                (error) in guard error == nil else {
                    print("😡Error adding document \(error!.localizedDescription)")
                    return completed(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)")
                
            }
            
            
        } else {
            let ref = db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).collection("locations").document(self.documentID)
            ref.setData(dataToSave) {
                (error) in guard error == nil else {
                    print("😡Error updating document \(error!.localizedDescription)")
                    return completed(false)
                }
                print("Updated Document: \(self.documentID)")
                
            }
        }
        
    }
    
    
    func deleteData(trip: Trip, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("trips").document(trip.documentID).collection("locations").document(documentID).delete() { error in
            if let error = error {
                print("Error: deleting review \(self.documentID)")
                completion(false)
            } else {
                print("successfully deleted \(self.documentID)")
            }
        }
    }

    
}
