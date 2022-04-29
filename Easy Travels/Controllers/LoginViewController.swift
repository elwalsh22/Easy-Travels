//
//  ViewController.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/12/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class LoginViewController: UIViewController {
    var authUI: FUIAuth!
    var user: TravelUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        // note FUIGoogleAuth line was previously: FUIGoogleAuth(), Google changed to line below in latest update
        let providers: [FUIAuthProvider] = [
          FUIGoogleAuth(authUI: authUI!),
        ]
        if authUI.auth?.currentUser == nil { // user has not signed in
            self.authUI.providers = providers // show providers named after let providers: above
            let loginViewController = authUI.authViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } else { // user is already logged in
            guard let currentUser = authUI.auth?.currentUser else {
                print("Error")
                return
            }
            let travelUser = TravelUser( user: currentUser)
            user = travelUser
            
            travelUser.saveIfNewUser { success in
                if success {
                    self.performSegue(withIdentifier: "FirstShowSegue", sender: nil)
                    //TODO: switch the segues once everything works
                    //self.performSegue(withIdentifier: "LogintoMain", sender: nil)
                } else {
                    print("error: tried to save a new user but failed")
                }
            }
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FirstShowSegue" {
            
            let destination = segue.destination as! WelcomeViewController
            print("login view controller user is \(user.documentID ?? "error")")
            destination.user = self.user
            
        } else if segue.identifier == "LogintoMain" {
            let destination = segue.destination as! MainViewController
            destination.user = self.user
        }
     
    }
    
    func signOut() {
        do {
            try authUI!.signOut()
        } catch {
            print("😡 ERROR: couldn't sign out")
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
}
}

    extension LoginViewController: FUIAuthDelegate {
        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            let marginInsets: CGFloat = 16.0 // amount to indent UIImageView on each side
            let topSafeArea = self.view.safeAreaInsets.top

            // Create an instance of the FirebaseAuth login view controller
            let loginViewController = FUIAuthPickerViewController(authUI: authUI)

            // Set background color to white
            loginViewController.view.backgroundColor = UIColor.white
            loginViewController.view.subviews[0].backgroundColor = UIColor.clear
            loginViewController.view.subviews[0].subviews[0].backgroundColor = UIColor.clear

            // Create a frame for a UIImageView to hold our logo
            let x = marginInsets
            let y = marginInsets //+ topSafeArea (took this out to move logo up)
            let width = self.view.frame.width - (marginInsets * 2)
            //        let height = loginViewController.view.subviews[0].frame.height - (topSafeArea) - (marginInsets * 2)
            let height = UIScreen.main.bounds.height - (topSafeArea) - (marginInsets * 2)

            let logoFrame = CGRect(x: x, y: y, width: width, height: height)

            // Create the UIImageView using the frame created above & add the "logo" image
            let logoImageView = UIImageView(frame: logoFrame)
           logoImageView.image = UIImage(named: "logo")
            logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
            loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
            return loginViewController
        }
        
        
    

}
