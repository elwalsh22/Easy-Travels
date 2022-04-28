//
//  PackingListViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit

class PackingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemLabel: UILabel!
    var items: PackingItems!
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.setToolbarHidden(false, animated: false)
        items = PackingItems()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if trip.documentID != "" {

        }
        items.loadData(trip: trip) {
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "AddItem":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! PackingDetailViewController
            destination.trip = trip
            destination.items = items
        case "ShowTripDetails":
            let destination = segue.destination as! TripDetailsViewController
            destination.trip = trip
            destination.items = items
        default:
            print("couldn't find a case for segue identifier. this should not have happened")
        }
    }
    
    @IBAction func unwindtoPackingListViewController(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "AddItem", sender: nil)
    
    }
    
    
}

extension PackingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PackingItemsTableViewCell
        
        cell.itemLabel.text? = items.itemsArray[indexPath.row].itemName
        cell.qtyLabel.text? = "\(items.itemsArray[indexPath.row].quantity)"
        
        return cell
    }
    
    
    
    
    
}
