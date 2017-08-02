//
//  TableViewController.swift
//  OrbClient
//
//  Created by NIKHILESH on 19/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, LineChartDelegate {
    var index = 0
    var homeData = HomeData()
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var lblCount1: UILabel!
    @IBOutlet weak var lblCount2: UILabel!
    @IBOutlet weak var lblCount3: UILabel!
    @IBOutlet weak var lblCount4: UILabel!
    @IBOutlet weak var lblCount5: UILabel!
    @IBOutlet weak var vwLineChartBase: UIView!
    
    var vwLineChart: LineChart!
    @IBOutlet weak var vwBannerClicks: UIView!
    @IBOutlet weak var constVwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.bindData()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrlVw.contentSize = CGSize(width: ScreenWidth, height: 700)
    }
    func bindData()
    {
        if homeData.arrOverView.count > 0
        {
            if index == 0
            {
                lblCount1.text = homeData.arrOverView[0].imageCount
                lblCount2.text = homeData.arrOverView[1].imageCount
                lblCount3.text = homeData.arrOverView[2].imageCount
                lblCount4.text = homeData.arrOverView[3].imageCount
                lblCount5.text = homeData.arrOverView[7].imageCount
                constVwBannerHeight.constant = 115
                vwBannerClicks.isHidden = false
                if homeData.arrOverView.count > 7
                {
                    let data: [CGFloat] = [CGFloat((Int(homeData.arrOverView[6].imageCount)!/1000)),CGFloat((Int(homeData.arrOverView[5].imageCount)!/1000)),CGFloat((Int(homeData.arrOverView[4].imageCount)!/1000))]
                    let currentMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
                    let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                    let last2Month = Calendar.current.date(byAdding: .month, value: -2, to: Date())
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "MMM YYYY"
                    
                    let xLabels: [String] = [dateFormatter.string(from: last2Month!), dateFormatter.string(from: lastMonth!), dateFormatter.string(from: currentMonth!)]
                    vwLineChart = LineChart()
                    vwLineChart.frame = vwLineChartBase.bounds
                    vwLineChart.animation.enabled = true
                    vwLineChart.area = false
                    vwLineChart.x.labels.visible = true
                    vwLineChart.x.grid.count = 5
                    vwLineChart.y.grid.count = 5
                    vwLineChart.x.labels.values = xLabels
                    vwLineChart.y.labels.visible = true
                    vwLineChart.dots.color = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                    vwLineChart.addLine(data)
                    self.vwLineChartBase.addSubview(vwLineChart)
                    vwLineChart.translatesAutoresizingMaskIntoConstraints = false
                    vwLineChart.delegate = self
                    
                }

            }
            else if index == 1
            {
                lblCount1.text = homeData.arrOverView[0].videoCount
                lblCount2.text = homeData.arrOverView[1].videoCount
                lblCount3.text = homeData.arrOverView[2].videoCount
                lblCount4.text = homeData.arrOverView[3].videoCount
                constVwBannerHeight.constant = 0
                 vwBannerClicks.isHidden = true
                if homeData.arrOverView.count > 7
                {
                    let data: [CGFloat] = [CGFloat((Int(homeData.arrOverView[6].videoCount)!/1000)),CGFloat((Int(homeData.arrOverView[5].videoCount)!/1000)),CGFloat((Int(homeData.arrOverView[4].videoCount)!/1000))]
                    let currentMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
                    let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                    let last2Month = Calendar.current.date(byAdding: .month, value: -2, to: Date())
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "MMM YYYY"
                    
                    let xLabels: [String] = [dateFormatter.string(from: last2Month!), dateFormatter.string(from: lastMonth!), dateFormatter.string(from: currentMonth!)]
                    vwLineChart = LineChart()
                    vwLineChart.frame = vwLineChartBase.bounds
                    vwLineChart.animation.enabled = true
                    vwLineChart.area = false
                    vwLineChart.x.labels.visible = true
                    vwLineChart.x.grid.count = 5
                    vwLineChart.y.grid.count = 5
                    vwLineChart.x.labels.values = xLabels
                    vwLineChart.y.labels.visible = true
                    vwLineChart.dots.color = UIColor(red: 255.0/255.0, green: 23.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                    vwLineChart.addLine(data)
                    self.vwLineChartBase.addSubview(vwLineChart)
                    vwLineChart.translatesAutoresizingMaskIntoConstraints = false
                    vwLineChart.delegate = self
                }
            }
        }
    }
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        print("x: \(x)     y: \(yValues)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
