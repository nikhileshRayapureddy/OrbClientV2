//
//  DLDemoRootViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

class RootViewController: SideMenu,SideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! UINavigationController
        //++ need to check
        self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "DLDemoMenuViewController") as! DLDemoMenuViewController
        self.view.backgroundColor = UIColor.clear
        self.delegate = self
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, didPerformPanGesture gestureRecognizer: UIPanGestureRecognizer)
     {
        
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, willShowMenuViewController menuViewController: UIViewController)
     {
        
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, didShowMenuViewController menuViewController: UIViewController)
     {
        
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, willHideMenuViewController menuViewController: UIViewController)
     {
        
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, didHideMenuViewController menuViewController: UIViewController)
     {
        
    }
     func hamburguerViewController(hamburguerViewController: SideMenu, willTransitionToSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
     {
        
    }
    // Support for legacy iOS 7 rotation.
     internal func hamburguerViewController(hamburguerViewController: SideMenu, willAnimateRotationToInterfaceOrientation toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
    
     {
        
    }
}
