//
//  SigninViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 17/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
let app_delegate =  UIApplication.shared.delegate as! AppDelegate

class SigninViewController: BaseViewController,ParserDelegate {

    @IBOutlet weak var txtFldUserId: FloatLabelTextField!
    
    @IBOutlet weak var lblWishText: UILabel!
    @IBOutlet weak var txtFldPwd: FloatLabelTextField!
    @IBOutlet weak var constVwBottomHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        OrbUserDefaults.setLoginStatus(object: "false")
        // Do any additional setup after loading the view.

//        txtFldUserId.text = "demo1@myryd.com"
//        txtFldPwd.text = "password"
//        txtFldUserId.text = "nishab@tminetwork.com"
//        txtFldPwd.text = "Op12uhgcoo$!"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    @IBAction func btnForgotPwdClicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func btnRememberMeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            OrbUserDefaults.setLoginStatus(object: "true")
        }
        else
        {
            OrbUserDefaults.setLoginStatus(object: "false")
        }
    }
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        
        if txtFldUserId.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter your Email-Id.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        else if txtFldPwd.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter your Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        else if validateUserEmail(emailAdd: txtFldUserId.text!) == false
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid Email-Id.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            OrbUserDefaults.setUserName(object: txtFldUserId.text!)
            OrbUserDefaults.setKeyWord(object: txtFldPwd.text!)
            self.doLoginWith(username: txtFldUserId.text!, key: txtFldPwd.text!)
            
        }
        
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        let user = object as! UserBO
        print(user.email)
        DispatchQueue.main.async {
            if OrbUserDefaults.getIsAddAgency() == true
            {
                self.navigateToMyClients()
            }
            else
            {
                self.navigateToHome()
            }
        }
    }
    func doLoginWith(username : String,key : String)
    {
        app_delegate.showLoader(message: "Authenticating...")
        let Bl = BusinessLayerClass()
        Bl.callBack = self
        Bl.doLoginWith(username: username, key: key)
    }
    func navigateToHome()
    {
        OrbUserDefaults.setLoginStatus(object: "true")
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewViewController") as! OverviewViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToMyClients()
    {
        OrbUserDefaults.setLoginStatus(object: "true")
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyClientsViewController") as! MyClientsViewController
        vc.isFirstTime = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
func validateUserEmail(emailAdd : String) -> Bool
{
    let emailRegex : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest =  NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: emailAdd)
}
