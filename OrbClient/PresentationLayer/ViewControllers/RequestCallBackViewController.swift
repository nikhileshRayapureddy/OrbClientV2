//
//  RequestCallBackViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 22/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class RequestCallBackViewController: BaseViewController,ParserDelegate {
    @IBOutlet weak var txtFldSub: FloatLabelTextField!
    @IBOutlet weak var txtVwMsg: UITextView!
    @IBOutlet weak var btnReqCallBack: UIButton!
    @IBOutlet weak var vwTxtVwBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBarWith(title: "Request call back",isSync: false)
        vwTxtVwBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        vwTxtVwBg.layer.borderWidth = 0.5
        txtFldSub.layer.cornerRadius = 5
        txtFldSub.layer.masksToBounds = true
    }
    func reqCallBackService()
    {
        app_delegate.showLoader(message: "Requesting call back...")
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.reqCallbackWith(subject: txtFldSub.text!, msg: txtVwMsg.text!)
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sorry!", message: error!, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thank you!", message: object as? String, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (act) in
                DispatchQueue.main.async {
                    self.txtVwMsg.text = ""
                    self.txtFldSub.text = ""
                }
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func btnReqCallBackClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if txtFldSub.text == ""
        {
            self.showAlertWith(title: "Alert!", message: "Please enter subject.")
        }
        else if txtVwMsg.text == ""
        {
            self.showAlertWith(title: "Alert!", message: "Please enter Message.")
        }
        else
        {
            if app_delegate.isServerReachable
            {
                self.reqCallBackService()
            }
            else
            {
                self.showAlertWith(title: "Alert!", message:NO_INTERNET)
            }

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
