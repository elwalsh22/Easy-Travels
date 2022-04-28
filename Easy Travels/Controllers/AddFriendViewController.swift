//
//  AddFriendViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/28/22.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    var users: TravelUsers!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if users == nil {
            users = TravelUsers()
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReturnTripDetail" {
            let destination = segue.destination as! TripDetailsViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.friends.userArray.append(users.userArray[selectedIndexPath.row] as! Friend)
        }
    }
    
    
}


extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.userArray.count
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.textLabel?.text = users.userArray[indexPath.row].displayName
    return cell
}


}
