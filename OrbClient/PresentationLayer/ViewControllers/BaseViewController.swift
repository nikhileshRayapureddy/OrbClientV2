//
//  BaseViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 19/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func designNavBarWith(title : String,isSync : Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBarBg"),for: .default)

        self.navigationController!.navigationBar.barTintColor = UIColor.clear//UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        let menuButton = UIButton(type: UIButtonType.custom)
        menuButton.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuClicked(sender:)), for: .touchUpInside)
        menuButton.contentHorizontalAlignment = .left
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        let tempButton = UIButton(type: UIButtonType.custom)
        tempButton.frame = CGRect(x: 45, y: 0  , width: 40 , height: 44)
        
        var rightBarButtonItem = UIBarButtonItem()
        if isSync
        {
            let btnSync = UIButton(type: UIButtonType.custom)
            btnSync.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
            btnSync.setImage(UIImage(named: "sync"), for: UIControlState.normal)
            btnSync.contentHorizontalAlignment = .right
            btnSync.addTarget(self, action: #selector(syncClicked(sender:)), for: .touchUpInside)
            rightBarButtonItem = UIBarButtonItem(customView: btnSync)
        }
        else
        {
            rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: -2, y: 0  , width: 44 , height: 44)))
        }
        
        let lblTitle = UILabel(frame:CGRect(x:0,y: 0,width: ScreenWidth,height: 44))
        lblTitle.textColor = UIColor.white
        lblTitle.text = title
        lblTitle.font = UIFont(name: "Helvetica-Bold", size: 17)
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.adjustsFontSizeToFitWidth = true

        self.navigationItem.titleView = lblTitle
        let leftBarButtonTemp: UIBarButtonItem = UIBarButtonItem(customView: tempButton)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem, leftBarButtonTemp]
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem, leftBarButtonTemp]

    }
    func designNavBarWith(title : String,isFilter : Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        let menuButton = UIButton(type: UIButtonType.custom)
        menuButton.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuClicked(sender:)), for: .touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        let tempButton = UIButton(type: UIButtonType.custom)
        tempButton.frame = CGRect(x: 45, y: 0  , width: 40 , height: 44)
        var rightBarButtonItem = UIBarButtonItem()
        if isFilter
        {
            let btnSync = UIButton(type: UIButtonType.custom)
            btnSync.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
            btnSync.setImage(UIImage(named: "filter"), for: UIControlState.normal)
            btnSync.addTarget(self, action: #selector(filterClicked(sender:)), for: .touchUpInside)
            rightBarButtonItem = UIBarButtonItem(customView: btnSync)
        }
        else
        {
            rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: -2, y: 0  , width: 44 , height: 44)))
        }
        
        let lblTitle = UILabel(frame:CGRect(x:0,y: 0,width: ScreenWidth,height: 44))
        lblTitle.textColor = UIColor.white
        lblTitle.text = title
        lblTitle.font = UIFont(name: "Helvetica-Bold", size: 17)
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.adjustsFontSizeToFitWidth = true
        
        self.navigationItem.titleView = lblTitle
        let leftBarButtonTemp: UIBarButtonItem = UIBarButtonItem(customView: tempButton)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem, leftBarButtonTemp]
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem, leftBarButtonTemp]
        
    }

    func designNavBarWith(title : String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let leftBarButtonTemp: UIBarButtonItem = UIBarButtonItem(customView: UIView())
        self.navigationItem.leftBarButtonItem = leftBarButtonTemp
        
        
        let lblTitle = UILabel(frame:CGRect(x:0,y: 0,width: ScreenWidth,height: 44))
        lblTitle.textColor = UIColor.white
        lblTitle.text = title
        lblTitle.font = UIFont(name: "Helvetica-Bold", size: 17)
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.adjustsFontSizeToFitWidth = true
        
        self.navigationItem.titleView = lblTitle
        
    }

    func menuClicked( sender:UIButton)
    {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    func syncClicked(sender:UIButton)
    {
        
    }
    func filterClicked(sender:UIButton)
    {
        
    }
    
    func showAlertWith(title : String,message : String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }
