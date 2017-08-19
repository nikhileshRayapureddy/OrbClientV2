//
//  ForgotPasswordViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 11/04/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController,ParserDelegate {

    @IBOutlet weak var txtFldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnResetPwdClicked(_ sender: UIButton) {
        if txtFldEmail.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Email-ID", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if validateUserEmail(emailAdd: txtFldEmail.text!) == false
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid Email-ID", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            if app_delegate.isServerReachable
            {
                self.resetPassword()
            }
            else
            {
                self.showAlertWith(title: "Alert!", message:NO_INTERNET)
            }

            
        }
    }
    
    func resetPassword()
    {
        app_delegate.showLoader(message: "Please wait...")
        let Bl = BusinessLayerClass()
        Bl.callBack = self
        Bl.forgotPasswordWith(email: txtFldEmail.text!)

    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert!", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
