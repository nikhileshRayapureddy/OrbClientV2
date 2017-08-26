//
//  DLDemoMenuViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

class DLDemoMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    // data
    var arrConstantLabels = [String]()//,"Settings"
    var arrConstantImages = [String]()//,"menu_settings"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblName.text = OrbUserDefaults.getName()
        lblBalance.text = OrbUserDefaults.getUserId()
        if OrbUserDefaults.getIsAddAgency() == true
        {
            arrConstantLabels = ["Overview","View or Update Ads","Coupons or Leads","Request call back","My Holdings","My clients","Share about us","Logout"]
            arrConstantImages = ["menu_overview","menu_upload","menu_coupon","menu_request_call_back","menu_request_call_back","menu_request_call_back","menu_share","menu_logout"]
        }
        else
        {
            arrConstantLabels = ["Overview","View or Update Ads","Coupons or Leads","Request call back","Share about us","Logout"]
            arrConstantImages = ["menu_overview","menu_upload","menu_coupon","menu_request_call_back","menu_share","menu_logout"]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrConstantLabels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)  as! MenuCell
            cell.backgroundColor = UIColor.clear
            cell.imgSep.isHidden = true
            cell.lblTitle.text = arrConstantLabels[indexPath.row]
            cell.lblTitle.textColor = UIColor.darkGray
                //UIColor(red: 115.0/255.0, green: 114.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        cell.imgVeItem.image = UIImage(named: arrConstantImages[indexPath.row])
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewViewController") as! OverviewViewController
            let navVC = UINavigationController.init(rootViewController: vc)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                    hamburguerViewController.contentViewController = navVC
                })
            }
        }
        else if indexPath.row == 1
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewOrUpdateViewController") as! ViewOrUpdateViewController
            let navVC = UINavigationController.init(rootViewController: vc)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                    hamburguerViewController.contentViewController = navVC
                })
            }
        }
        else if indexPath.row == 2
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CouponsOrLeadsViewController") as! CouponsOrLeadsViewController
            let navVC = UINavigationController.init(rootViewController: vc)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                    hamburguerViewController.contentViewController = navVC
                })
            }
        }
//        else if indexPath.row == 3
//        {
//            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
//            let navVC = UINavigationController.init(rootViewController: vc)
//            if let hamburguerViewController = self.findHamburguerViewController() {
//                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
//                    hamburguerViewController.contentViewController = navVC
//                })
//            }
//        }
        else if indexPath.row == 3
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestCallBackViewController") as! RequestCallBackViewController
            let navVC = UINavigationController.init(rootViewController: vc)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                    hamburguerViewController.contentViewController = navVC
                })
            }
        }
        else if indexPath.row == 4
        {
            if OrbUserDefaults.getIsAddAgency() == true
            {
                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyHoldingsViewController") as! MyHoldingsViewController
                let navVC = UINavigationController.init(rootViewController: vc)
                if let hamburguerViewController = self.findHamburguerViewController() {
                    hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                        hamburguerViewController.contentViewController = navVC
                    })
                }
            }
            else
            {
                if let hamburguerViewController = self.findHamburguerViewController() {
                    hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                        let vc = UIActivityViewController(activityItems: ["I'm using Orb to enhance my brand, why don't you try? Contact Details - prithvi@taksykraft.com, 84660 98869 or sharath@taksykraft.com, 76608 76601"], applicationActivities: [])
                        hamburguerViewController.contentViewController.present(vc, animated: true)
                    })
                }
            }

        }
        else if indexPath.row == 5
        {
            if OrbUserDefaults.getIsAddAgency() == true
            {
                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyClientsViewController") as! MyClientsViewController
                let navVC = UINavigationController.init(rootViewController: vc)
                if let hamburguerViewController = self.findHamburguerViewController() {
                    hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                        hamburguerViewController.contentViewController = navVC
                    })
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: { (act) in
                        DispatchQueue.main.async {
                            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                            OrbUserDefaults.setLoginStatus(object: "false")
                            let navVC = UINavigationController.init(rootViewController: vc)
                            if let hamburguerViewController = self.findHamburguerViewController() {
                                hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                                    hamburguerViewController.contentViewController = navVC
                                })
                            }
                        }
                    })
                    alert.addAction(action)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            
        }
        else if indexPath.row == 6
        {
            if OrbUserDefaults.getIsAddAgency() == true
            {
                if let hamburguerViewController = self.findHamburguerViewController() {
                    hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                        let vc = UIActivityViewController(activityItems: ["I'm using Orb to enhance my brand, why don't you try? Contact Details - prithvi@taksykraft.com, 84660 98869 or sharath@taksykraft.com, 76608 76601"], applicationActivities: [])
                        hamburguerViewController.contentViewController.present(vc, animated: true)
                    })
                }
            }
            
        }
        else
        {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (act) in
                    DispatchQueue.main.async {
                        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        OrbUserDefaults.setLoginStatus(object: "false")
                        let navVC = UINavigationController.init(rootViewController: vc)
                        if let hamburguerViewController = self.findHamburguerViewController() {
                            hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                                hamburguerViewController.contentViewController = navVC
                            })
                        }
                    }
                })
                alert.addAction(action)
                alert.addAction(UIAlertAction(title: "CanceZ", style: .default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
            

        }
    }
    
    // MARK: - Navigation
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "DLDemoNavigationViewController") as! DLHamburguerNavigationController
    }
    

}
