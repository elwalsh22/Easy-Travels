//
//  PackingDetailViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/27/22.
//

import UIKit

class PackingDetailViewController: UIViewController {
    
    var trip: Trip!
    var item: PackingItem!
    var items: PackingItems!
    
    var count: Int = 0 {
        didSet {
            quantityTextField.text = "\(count)"
        }
    }
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard trip != nil else {
            print("no spot passed to ReviewTableViewController.swift")
            return
        }
        if item == nil {
            item = PackingItem()
        }
        updateUserInterface()
    }
    
    
    func updateUserInterface() {
        
        itemTextField.text = item.itemName
        quantityTextField.text = "\(item.quantity)"
        
    }
    func updateFromUserInterface() {
        item.itemName = itemTextField.text!
        item.quantity = Int(quantityTextField.text!) ?? 0
        print("item quantity is \(item.quantity)")
    }
    @IBAction func stepperPressed(_ sender: UIStepper) {
        count = Int(stepper.value)
    }
    @IBAction func itemNameChanged(_ sender: UITextField) {
        let noSpaces = itemTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromUserInterface()
        item.saveData(trip: trip) { (success) in
            if success {
                print("save button pressed")
                self.items.itemsArray.append(self.item)
                let destination = segue.destination as! PackingListViewController
                
                destination.items = self.items
                destination.trip = self.trip
            }else {
                print("error: can't unwind segue from review because of review saving error")
            }
        }
    }
       
        
    }
    
   
//    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
//        updateFromUserInterface()
//        item.saveData(trip: trip) { (success) in
//            if success {
//                print("save button pressed")
//                self.items.itemsArray.append(self.item)
//            }else {
//                print("error: can't unwind segue from review because of review saving error")
//            }
//        }
//    }



