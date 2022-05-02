//
//  Trip.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import Foundation
import FirebaseFirestore
import Firebase
import MapKit


class Trip: NSObject, MKAnnotation{
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var numberOfLocations: Int
    var numberOfItems: Int
    var postingUserID: String
    var departureDate: Date
    var returnDate: Date
    var index: Int
    var documentID: String
    
    var dictionary: [String: Any] {
        let departureTimeIntervalDate = departureDate.timeIntervalSince1970
        let returnTimeIntervalDate = departureDate.timeIntervalSince1970
        return ["name" : name , "address": address, "latitude": latitude, "longitude": longitude, "numberOfLocations": numberOfLocations, "numberOfItems": numberOfItems, "departureDate": departureTimeIntervalDate,"returnDate": returnTimeIntervalDate, "index": index, "postingUserID" : postingUserID]
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
        return name
    }
    var subtitle: String? {
        return address
    }
    
    
    
    convenience override init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), numberOfLocations: 0 , numberOfItems: 0 , departureDate: Date(), returnDate: Date(), index: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(name: String, departureDate: Date, returnDate: Date) {
        self.init(name: name, address: "", coordinate: CLLocationCoordinate2D(), numberOfLocations: 0 , numberOfItems: 0 , departureDate: departureDate , returnDate: returnDate, index: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let numberOfLocations = dictionary["numberOfLocations"] as! Int? ?? 0
        let numberOfItems = dictionary["numberOfItems"] as! Int? ?? 0
        let index = dictionary["index"] as! Int? ?? 0
        let departureTimeIntervalDate = dictionary["departureDate"] as! TimeInterval? ??  TimeInterval()
        let departureDate = Date(timeIntervalSince1970: departureTimeIntervalDate)
        let returnTimeIntervalDate = dictionary["returnDate"] as! TimeInterval? ??  TimeInterval()
        let returnDate = Date(timeIntervalSince1970: returnTimeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        
        
        self.init(name: name, address: address, coordinate: coordinate, numberOfLocations: numberOfLocations, numberOfItems: numberOfItems ,departureDate:departureDate, returnDate:returnDate, index: index, postingUserID: postingUserID, documentID: "")
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D,  numberOfLocations: Int, numberOfItems: Int, departureDate: Date, returnDate: Date, index: Int, postingUserID: String, documentID: String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.numberOfLocations = numberOfLocations
        self.numberOfItems = numberOfItems
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.index = index
        self.postingUserID = postingUserID
        self.documentID = documentID
        
    }
    
    func saveData(user: TravelUser, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
                    print("*** ERROR: Could not save data because we don't have a valid postingUserID")
                    return completed(false)
                }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave: [String: Any] = self.dictionary
        
        //if we have a saved record we'll have an ID
        
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("users").document(user.documentID).collection("trips").addDocument(data: dataToSave) {
                (error) in guard error ==  nil else{
                    print("😡Error adding document \(error!.localizedDescription)")
                    return completed(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)")
                completed(true)
            }
        } else {
            let ref = db.collection("users").document(user.documentID).collection("trips").document(self.documentID)
            ref.setData(dataToSave) {    (error) in guard error ==  nil else{
                print("😡Error updating document \(error!.localizedDescription)")
                return completed(false)
            }
                print("Updated Document: \(self.documentID)")
                completed(true)
            }
        }
    }
    
    
    func deleteData(user: TravelUser, trip: Trip, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(user.documentID).collection("trips").document(trip.documentID).delete() { error in
            if let error = error {
                print("Error: deleting review \(self.documentID)")
                completion(false)
            } else {
                print("successfully deleted \(self.documentID)")
            }
        }
    }
    

}

