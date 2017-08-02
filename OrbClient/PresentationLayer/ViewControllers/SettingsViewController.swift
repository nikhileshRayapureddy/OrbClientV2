//
//  SettingsViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 22/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "Settings",isSync: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
