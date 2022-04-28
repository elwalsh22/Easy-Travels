//
//  HomeViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: TravelUser!
    var trips: Trips!

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuBtn.target = revealViewController()
                sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        
    }
    


}
