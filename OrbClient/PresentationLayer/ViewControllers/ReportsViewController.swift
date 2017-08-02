//
//  ReportsViewController.swift
//  OrbClient
//
//  Created by Nikhilesh on 23/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController,SimpleBarChartDelegate,SimpleBarChartDataSource {
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet weak var vwBaseBanner: UIView!
    @IBOutlet weak var vwBaseVideo: UIView!
    @IBOutlet weak var lblVwBaseViews: UILabel!
    @IBOutlet weak var lblVwBaseVideoViews: UILabel!
    @IBOutlet weak var lblVwBaseBannerViews: UILabel!
    
    @IBOutlet weak var lblVwBaseDays: UILabel!
    @IBOutlet weak var lblVwBaseBannerDays: UILabel!
    @IBOutlet weak var lblVwBaseVideoDays: UILabel!
    
    
    var homeData = HomeData()
    var chart = SimpleBarChart()
    var chartBanner = SimpleBarChart()
    var chartVideo = SimpleBarChart()
    
    override func loadView() {
        super.loadView()
        chart = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width-25, height: 280))
        chart.delegate = self;
        chart.dataSource = self;
        chart.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        chart.animationDuration = 1.0;
        chart.barShadowColor = UIColor.gray
        chart.barShadowAlpha = 0.5;
        chart.barShadowRadius = 1.0;
        chart.barWidth = 25.0;
        chart.xLabelType = SimpleBarChartXLabelTypeVerticle;
        chart.incrementValue = 10;
        chart.barTextType = SimpleBarChartBarTextTypeTop;
        chart.barTextColor = UIColor.white
        chart.gridColor = UIColor.lightGray
        vwBase.addSubview(chart)
        
        
        chartBanner = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width-25, height: 280))
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
        
        chartVideo = SimpleBarChart(frame: CGRect(x: 20, y: 30, width: self.view.frame.size.width-25, height: 280))
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
        lblVwBaseViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lblVwBaseBannerViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        lblVwBaseVideoViews.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chart.reloadData()
        chartVideo.reloadData()
        chartBanner.reloadData()
    }
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        if barChart == chart
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
        if barChart == chart
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
        if barChart == chart
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
        dateFormatter.dateFormat = "YYYY-MM-DD"

        if barChart == chart
        {
            let chartData = homeData.arrImage[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-DD"
            return dateFormatter.string(from:date!)
        }
        else if barChart == chartBanner
        {
            let chartData = homeData.arrBanner[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-DD"
            return dateFormatter.string(from:date!)
        }
        else
        {
            let chartData = homeData.arrVideo[index]
            let date = dateFormatter.date(from: chartData.date)
            dateFormatter.dateFormat = "MMM-DD"
            return dateFormatter.string(from:date!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
