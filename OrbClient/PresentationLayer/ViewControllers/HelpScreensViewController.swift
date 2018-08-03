//
//  HelpScreensViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 19/08/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class HelpScreensViewController: BaseViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrlVwHelpScreens: UIScrollView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var constVwBaseWidth: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
            scrlVwHelpScreens.contentSize = CGSize(width: self.view.bounds.size.width * 3, height: self.view.bounds.size.height - 60)
        constVwBaseWidth.constant = self.view.bounds.size.width * 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnSkipClicked(_ sender: UIButton) {
       let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        
        let rootVC = app_delegate.window?.rootViewController as? RootViewController
        rootVC?.contentViewController = UINavigationController.init(rootViewController: vc)
        OrbUserDefaults.setHelpScreenStatus(object: "true")
    }
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let  pageNo = round(scrlVwHelpScreens.contentOffset.x / scrlVwHelpScreens.frame.size.width) as CGFloat
        pageControl.currentPage = Int(pageNo + 1)

        if pageNo == 1
        {
            btnNext.setTitle("DONE", for: .normal)
            scrlVwHelpScreens.setContentOffset(CGPoint(x: ScreenWidth * (pageNo+1), y: scrlVwHelpScreens.contentOffset.y), animated: true)

        }
        else if pageNo == 2
        {
            self.btnSkipClicked(sender)
        }
        else
        {
            btnNext.setTitle("NEXT", for: .normal)
            scrlVwHelpScreens.setContentOffset(CGPoint(x: ScreenWidth * (pageNo+1), y: scrlVwHelpScreens.contentOffset.y), animated: true)
        }
        
    }
   
    @IBAction func pageControlChanged(_ sender: Any) {
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // let  pageWidth = scrlVwBanner.frame.size.width as CGFloat
        let  pageNo = round(scrlVwHelpScreens.contentOffset.x / scrlVwHelpScreens.frame.size.width) as CGFloat
        pageControl.currentPage = Int(pageNo)
        if pageNo == 2
        {
            btnNext.setTitle("DONE", for: .normal)
        }
        else
        {
            btnNext.setTitle("NEXT", for: .normal)
        }

    }
}
