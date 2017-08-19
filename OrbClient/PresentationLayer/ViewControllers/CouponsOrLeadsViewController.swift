//
//  CouponsOrLeadsViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 22/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
import MessageUI

class CouponsOrLeadsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,ParserDelegate,MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var tblVwLeads: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var arrLeads = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "Leads",isSync: true)
        if app_delegate.isServerReachable
        {
            self.getAllLeads()
        }
        else
        {
            self.showAlertWith(title: "Alert!", message:NO_INTERNET)
        }

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeads.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeadCustomCell = tableView.dequeueReusableCell(withIdentifier: "LeadCustomCell", for: indexPath)  as! LeadCustomCell
        cell.backgroundColor = UIColor.clear
        cell.lblMobileNo.text = arrLeads[indexPath.row]
        cell.btnCall.tag = indexPath.row + 5000
        cell.btnMsg.tag = indexPath.row + 9000
        cell.btnCall.addTarget(self, action: #selector(btnCallClicked(sender:)), for: .touchUpInside)
        cell.btnMsg.addTarget(self, action: #selector(btnMsgClicked(sender:)), for: .touchUpInside)
        return cell

    }
    override func syncClicked(sender:UIButton)
    {
        if app_delegate.isServerReachable
        {
            self.getAllLeads()
        }
        else
        {
            self.showAlertWith(title: "Alert!", message:NO_INTERNET)
        }
    }

    func btnCallClicked(sender : UIButton)
    {
        guard let number = URL(string: "telprompt://" + arrLeads[sender.tag - 5000]) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    func btnMsgClicked(sender : UIButton)
    {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hi Please install Orb"
            controller.recipients = [arrLeads[sender.tag - 9000]]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func getAllLeads()
    {
        app_delegate.showLoader(message: "Fetching..")
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.getLeads()
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        arrLeads = object as! [String]
        DispatchQueue.main.async {
            
            if self.arrLeads.count > 0
            {
                self.tblVwLeads.isHidden = false
                self.lblNoDataFound.isHidden = true
                self.tblVwLeads.reloadData()
            }
            else
            {
                self.tblVwLeads.isHidden = true
                self.lblNoDataFound.isHidden = false
            }
            
        }
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
