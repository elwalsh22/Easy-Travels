//
//  MainViewController.swift
//  Easy Travels
//  Attribution: johncodeos.com tutorial on side menus
//  Created by Ella Walsh on 4/24/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class MainViewController: UIViewController {

  
    private var sideMenuShadowView: UIView!

    private var sideMenuViewController: SideMenuViewController!
        private var sideMenuRevealWidth: CGFloat = 260
        private let paddingForRotation: CGFloat = 150
        private var isExpanded: Bool = false

        // Expand/Collapse the side menu by changing trailing's constant
        private var sideMenuTrailingConstraint: NSLayoutConstraint!

        private var revealSideMenuOnTop: Bool = true
    
    var user: TravelUser!
        override public func viewDidLoad() {
            super.viewDidLoad()
            
           
            
            
            self.view.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)

            // Shadow Background View
                    self.sideMenuShadowView = UIView(frame: self.view.bounds)
                    self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.sideMenuShadowView.backgroundColor = .black
                    self.sideMenuShadowView.alpha = 0.0
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
                    tapGestureRecognizer.numberOfTapsRequired = 1
                    tapGestureRecognizer.delegate = self
                    view.addGestureRecognizer(tapGestureRecognizer)
                    if self.revealSideMenuOnTop {
                        view.insertSubview(self.sideMenuShadowView, at: 1)
                    }


            // Side Menu
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
            self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
            self.sideMenuViewController.delegate = self
            view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
            addChild(self.sideMenuViewController!)
            self.sideMenuViewController!.didMove(toParent: self)

            // Side Menu AutoLayout

            self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
                self.sideMenuTrailingConstraint.isActive = true
            }
            NSLayoutConstraint.activate([
                self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
                self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
            ])

            // ...


           // Default Main View Controller
           showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
         
        }
       
    
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Home
            self.showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        case 1:
            
            self.showViewController(viewController: UINavigationController.self, storyboardId: "TripsNavID")
        case 2:
            
            self.showViewController(viewController: UINavigationController.self, storyboardId: "UsersNavID")
            
        
        default:
            break
        }

        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }

    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        vc.didMove(toParent: self)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is MainViewController {
            return viewController! as? MainViewController
        }
        while (!(viewController is MainViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        return nil
    }
    
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
}


extension MainViewController: FUIAuthDelegate {
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
        let y = marginInsets + topSafeArea
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
