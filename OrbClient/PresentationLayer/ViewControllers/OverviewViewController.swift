//
//  ViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 14/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
class OverviewViewController:  BaseViewController,ParserDelegate {
    var isShare = false
    var homeData = HomeData()
  var arrGlobal = [String]()

    @IBOutlet weak var scrlVwHorizontal: UIScrollView!
    @IBOutlet weak var btnBanner: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    @IBOutlet weak var vwBannersBg: UIView!
    @IBOutlet weak var vwVideosBg: UIView!
    @IBOutlet weak var vwReportsBg: UIView!
    
    @IBOutlet weak var costBgLeading: NSLayoutConstraint!
    
    @IBOutlet weak var scrlVwBanners: UIScrollView!
    @IBOutlet weak var vwBanners: UIView!
    @IBOutlet weak var lblBannersRightNowCount: UILabel!
    @IBOutlet weak var lblBannersSoFarCount: UILabel!
    @IBOutlet weak var lblBannersYesterdayCount: UILabel!
    @IBOutlet weak var lblBannersLast30DaysCount: UILabel!
    @IBOutlet weak var lblBanners30DaysClicks: UILabel!
    @IBOutlet weak var vwBannersLineChartBase: UIView!
    var vwBannersLineChart: LineChart!

    @IBOutlet weak var lblNoRecords: UILabel!
    
    
    
    @IBOutlet weak var scrlVwVideos: UIScrollView!
    @IBOutlet weak var vwVideos: UIView!
    @IBOutlet weak var lblVideosRightNowCount: UILabel!
    @IBOutlet weak var lblVideosSoFarCount: UILabel!
    @IBOutlet weak var lblVideosYesterdayCount: UILabel!
    @IBOutlet weak var lblVideosLast30DaysCount: UILabel!
    @IBOutlet weak var vwVideosLineChartBase: UIView!
    var vwVideosLineChart: LineChart!

    
    
    
    

    @IBOutlet weak var scrlVwReports: UIScrollView!
    @IBOutlet weak var vwReports: UIView!

    @IBOutlet weak var vwBaseImage: UIView!
    @IBOutlet weak var vwBaseBanner: UIView!
    @IBOutlet weak var vwBaseVideo: UIView!
    
    @IBOutlet weak var lblVwBaseImageViews: UILabel!
    @IBOutlet weak var lblVwBaseVideoViews: UILabel!
    @IBOutlet weak var lblVwBaseBannerViews: UILabel!
    
    @IBOutlet weak var lblVwBaseImageDays: UILabel!
    @IBOutlet weak var lblVwBaseBannerDays: UILabel!
    @IBOutlet weak var lblVwBaseVideoDays: UILabel!

    var chartImage = SimpleBarChart()
    var chartBanner = SimpleBarChart()
    var chartVideo = SimpleBarChart()
    
    
    @IBOutlet weak var constVwBaseimageHeight: NSLayoutConstraint!
    @IBOutlet weak var constVwBaseBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var constVwBaseVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var constVwReportsHeight: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        chartImage = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: vwBaseImage.frame.size.width-25, height: 280))
        chartImage.delegate = self;
        chartImage.dataSource = self;
        chartImage.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        chartImage.animationDuration = 1.0;
        chartImage.barShadowColor = UIColor.gray
        chartImage.barShadowAlpha = 0.5;
        chartImage.barShadowRadius = 1.0;
        chartImage.barWidth = 25.0;
        chartImage.xLabelType = SimpleBarChartXLabelTypeVerticle;
        chartImage.incrementValue = 10;
        chartImage.barTextType = SimpleBarChartBarTextTypeTop;
        chartImage.barTextColor = UIColor.white
        chartImage.gridColor = UIColor.lightGray
        vwBaseImage.addSubview(chartImage)
        
        
        chartBanner = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: vwBaseBanner.frame.size.width-25, height: 280))
        chartBanner.delegate = self;
        chartBanner.dataSource = self;
        chartBanner.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        chartBanner.animationDuration = 1.0;
        chartBanner.barShadowColor = UIColor.gray
        chartBanner.barShadowAlpha = 0.5;
        chartBanner.barShadowRadius = 1.0;
        chartBanner.barWidth = 25.0;
        chartBanner.xLabelType = SimpleBarChartXLabelTypeVerticle;
        chartBanner.incrementValue = 10;
        chartBanner.barTextType = SimpleBarChartBarTextTypeTop;
        chartBanner.barTextColor = UIColor.white
        chartBanner.gridColor = UIColor.lightGray
        vwBaseBanner.addSubview(chartBanner)
        
        chartVideo = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: vwBaseVideo.frame.size.width-25, height: 280))
        chartVideo.delegate = self;
        chartVideo.dataSource = self;
        chartVideo.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        chartVideo.animationDuration = 1.0;
        chartVideo.barShadowColor = UIColor.gray
        chartVideo.barShadowAlpha = 0.5;
        chartVideo.barShadowRadius = 1.0;
        chartVideo.barWidth = 25.0;
        chartVideo.xLabelType = SimpleBarChartXLabelTypeVerticle;
        chartVideo.incrementValue = 10;
        chartVideo.barTextType = SimpleBarChartBarTextTypeTop;
        chartVideo.barTextColor = UIColor.white
        chartVideo.gridColor = UIColor.lightGray
        vwBaseVideo.addSubview(chartVideo)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.designNavBarWith(title: "Real-Time Overview",isSync: true)
        arrGlobal = ["BANNER VIEWS","VIDEOS VIEWS","REPORTS"]
        self.automaticallyAdjustsScrollViewInsets = false
        
        lblVwBaseImageViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lblVwBaseBannerViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lblVwBaseVideoViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isShare
        {
            let vc = UIActivityViewController(activityItems: ["Hi, Please install OrbClient."], applicationActivities: [])
            present(vc, animated: true)

        }
        if app_delegate.isServerReachable
        {
            self.getUserData()
        }
        else
        {
            self.showAlertWith(title: "Alert!", message:NO_INTERNET)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVwHorizontal.contentSize = CGSize(width: self.view.bounds.size.width * 3, height: scrlVwHorizontal.frame.size.height)
        scrlVwBanners.contentSize = CGSize(width: vwBanners.frame.size.width, height: 700)
        
        scrlVwVideos.contentSize = CGSize(width: scrlVwVideos.frame.size.width, height: 700)

        scrlVwReports.contentSize = CGSize(width: scrlVwReports.frame.size.width, height: constVwReportsHeight.constant + 20)

    }
    @IBAction func btnBannerClicked(_ sender: UIButton) {
        costBgLeading.constant = 3
        self.scrlVwHorizontal.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.layoutIfNeeded()
            

        }) { (complete) in
            sender.isSelected = true
            self.btnVideo.isSelected = false
            self.btnReport.isSelected = false

        }
    }
    @IBAction func btnVideoClicked(_ sender: UIButton) {
        costBgLeading.constant = 3 + sender.frame.size.width
        self.scrlVwHorizontal.setContentOffset(CGPoint(x: self.view.bounds.size.width, y: 0), animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        }) { (complete) in
            sender.isSelected = true
            self.btnBanner.isSelected = false
            self.btnReport.isSelected = false
            
        }

    }
    @IBAction func btnReportClicked(_ sender: UIButton) {
        costBgLeading.constant = 3 + (2*sender.frame.size.width)
        self.scrlVwHorizontal.setContentOffset(CGPoint(x: self.view.bounds.size.width * 2, y: 0), animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        }) { (complete) in
            sender.isSelected = true
            self.btnVideo.isSelected = false
            self.btnBanner.isSelected = false
            
        }


    }

    func getUserData()
    {
        app_delegate.showLoader(message: "Loading....")
        let BL = BusinessLayerClass()
        BL.callBack = self
        BL.getUserData()
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        self.showAlertWith(title: "Alert!", message: error!)
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        homeData = object as! HomeData
        DispatchQueue.main.async {
            self.bindData()
        }
    }
    override func syncClicked(sender:UIButton)
    {
        if app_delegate.isServerReachable
        {
            self.getUserData()
            self.btnBannerClicked(self.btnBanner)
        }
        else
        {
            self.showAlertWith(title: "Alert!", message:NO_INTERNET)
        }
    }

    func bindData()
    {
        if homeData.arrOverView.count > 0
        {
            lblBannersRightNowCount.text = homeData.arrOverView[0].imageCount
            lblBannersSoFarCount.text = homeData.arrOverView[1].imageCount
            lblBannersYesterdayCount.text = homeData.arrOverView[2].imageCount
            lblBannersLast30DaysCount.text = homeData.arrOverView[3].imageCount
            lblBanners30DaysClicks.text = homeData.arrOverView[7].imageCount
            if homeData.arrOverView.count > 7
            {
                let data: [CGFloat] = [CGFloat((Int(homeData.arrOverView[6].imageCount)!/1000)),CGFloat((Int(homeData.arrOverView[5].imageCount)!/1000)),CGFloat((Int(homeData.arrOverView[4].imageCount)!/1000))]
//                let data: [CGFloat] = [CGFloat(8888),CGFloat(0),CGFloat(0)]

                let currentMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
                let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                let last2Month = Calendar.current.date(byAdding: .month, value: -2, to: Date())
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "MMM YYYY"
                
                let xLabels: [String] = [dateFormatter.string(from: last2Month!), dateFormatter.string(from: lastMonth!), dateFormatter.string(from: currentMonth!)]
                vwBannersLineChart = LineChart()
                vwBannersLineChart.frame = vwBannersLineChartBase.bounds
                vwBannersLineChart.animation.enabled = true
                vwBannersLineChart.area = false
                vwBannersLineChart.x.labels.visible = true
                vwBannersLineChart.x.grid.count = 5
                vwBannersLineChart.y.grid.count = 5
                vwBannersLineChart.x.labels.values = xLabels
                vwBannersLineChart.y.labels.visible = true
                vwBannersLineChart.dots.color = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                vwBannersLineChart.addLine(data)
                self.vwBannersLineChartBase.addSubview(vwBannersLineChart)
                vwBannersLineChart.translatesAutoresizingMaskIntoConstraints = false
                vwBannersLineChart.delegate = self
                
            }
            
            
            lblVideosRightNowCount.text = homeData.arrOverView[0].videoCount
            lblVideosSoFarCount.text = homeData.arrOverView[1].videoCount
            lblVideosYesterdayCount.text = homeData.arrOverView[2].videoCount
            lblVideosLast30DaysCount.text = homeData.arrOverView[3].videoCount
            if homeData.arrOverView.count > 7
            {
                let data: [CGFloat] = [CGFloat((Int(homeData.arrOverView[6].videoCount)!/1000)),CGFloat((Int(homeData.arrOverView[5].videoCount)!/1000)),CGFloat((Int(homeData.arrOverView[4].videoCount)!/1000))]
                let currentMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
                let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                let last2Month = Calendar.current.date(byAdding: .month, value: -2, to: Date())
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "MMM YYYY"
                
                let xLabels: [String] = [dateFormatter.string(from: last2Month!), dateFormatter.string(from: lastMonth!), dateFormatter.string(from: currentMonth!)]
                vwVideosLineChart = LineChart()
                vwVideosLineChart.frame = vwVideosLineChartBase.bounds
                vwVideosLineChart.animation.enabled = true
                vwVideosLineChart.area = false
                vwVideosLineChart.x.labels.visible = true
                vwVideosLineChart.x.grid.count = 5
                vwVideosLineChart.y.grid.count = 5
                vwVideosLineChart.x.labels.values = xLabels
                vwVideosLineChart.y.labels.visible = true
                vwVideosLineChart.dots.color = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                vwVideosLineChart.addLine(data)
                self.vwVideosLineChartBase.addSubview(vwVideosLineChart)
                vwVideosLineChart.translatesAutoresizingMaskIntoConstraints = false
                vwVideosLineChart.delegate = self
                
            }
            
            chartImage.incrementValue = 10
            chartVideo.incrementValue = 10
            chartBanner.incrementValue = 10
            
            
            if homeData.arrImage.count <= 0
            {
                constVwBaseimageHeight.constant = 0
                vwBaseImage.isHidden = true
            }
            else
            {
                constVwBaseimageHeight.constant = 330
                vwBaseImage.isHidden = false
            }
            if homeData.arrBanner.count <= 0
            {
                constVwBaseBannerHeight.constant = 0
                vwBaseBanner.isHidden = true
            }
            else
            {
                constVwBaseBannerHeight.constant = 330
                vwBaseBanner.isHidden = false
            }
            
            if homeData.arrVideo.count <= 0
            {
                constVwBaseVideoHeight.constant = 0
                vwBaseVideo.isHidden = true
            }
            else
            {
                constVwBaseVideoHeight.constant = 330
                vwBaseVideo.isHidden = false
            }
            
            constVwReportsHeight.constant = constVwBaseimageHeight.constant + constVwBaseVideoHeight.constant + constVwBaseBannerHeight.constant
            
            if constVwReportsHeight.constant > 0
            {
                constVwReportsHeight.constant = constVwReportsHeight.constant + 100
                lblNoRecords.isHidden = true
                vwReports.isHidden = false
                self.viewDidLayoutSubviews()
                
            }
            else
            {
                lblNoRecords.isHidden = false
                vwReports.isHidden = true
            }
            
            
            chartImage.reloadData()
            chartVideo.reloadData()
            chartBanner.reloadData()
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension OverviewViewController:LineChartDelegate
{
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        print("x: \(x)     y: \(yValues)")
    }

}
extension OverviewViewController:SimpleBarChartDelegate,SimpleBarChartDataSource {
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        if barChart == chartImage
        {
            return UInt(homeData.arrImage.count)
        }
        else if barChart == chartBanner
        {
            return UInt(homeData.arrBanner.count)
        }
        else
        {
            return UInt(homeData.arrVideo.count)
        }
    }
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: Int) -> String! {
        if barChart == chartImage
        {
            return homeData.arrImage[index].count
        }
        else if barChart == chartBanner
        {
            return homeData.arrBanner[index].count
        }
        else
        {
            return homeData.arrVideo[index].count
        }
        
    }
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: Int) -> CGFloat {
        if barChart == chartImage
        {
            let chartData = homeData.arrImage[index]
            return CGFloat(Int(chartData.count)!)
        }
        else if barChart == chartBanner
        {
            let chartData = homeData.arrBanner[index]
            return CGFloat(Int(chartData.count)!)
        }
        else
        {
            let chartData = homeData.arrVideo[index]
            return CGFloat(Int(chartData.count)!)
        }
    }
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: Int) -> UIColor! {
        return UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        
    }
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: Int) -> String! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if barChart == chartImage
        {
            let chartData = homeData.arrImage[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-dd"
            return dateFormatter.string(from:date!)
        }
        else if barChart == chartBanner
        {
            let chartData = homeData.arrBanner[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-dd"
            return dateFormatter.string(from:date!)
        }
        else
        {
            let chartData = homeData.arrVideo[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-dd"
            return dateFormatter.string(from:date!)
        }
    }

}
