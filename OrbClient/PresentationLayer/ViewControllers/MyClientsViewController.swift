//
//  MyClientsViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 20/05/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class MyClientsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblClients: UITableView!
    var isFirstTime = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if isFirstTime
        {
            self.designNavBarWith(title: "My Clients")
        }
        else
        {
            self.designNavBarWith(title: "My Clients",isSync: true)
        }

        // Do any additional setup after loading the view.
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ClientCustomCell = tableView.dequeueReusableCell(withIdentifier: "ClientCustomCell", for: indexPath)  as! ClientCustomCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = "Apollo Pharmacy"
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewViewController") as! OverviewViewController
        let navVC = UINavigationController.init(rootViewController: vc)
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.hideMenuViewControllerWithCompletion(completion: { () -> Void in
                hamburguerViewController.contentViewController = navVC
            })
        }

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
