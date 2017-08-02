
//
//  BusinessLayerClass.swift
//  BestPrice
//
//  Created by Mery Rani on 1/9/16.
//  Copyright © 2016 martjack. All rights reserved.
//

import Foundation
import UIKit
let SOAP_ACTION = "SOAPAction"
let CONTENT_LENGTH = "Content-Length"
let CONTENT_TYPE  = "Content-Type"

let NO_INTERNET = "No Internet Access. Check your network and try again."
let SERVER_ERROR = "Server not responding.\nPlease try after some time."

let developer_API = "http://myryd.com/api/v1/"

let ScreenWidth =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let image = "image"
let banner = "bannerimage"
let video = "video"
class BusinessLayerClass: BaseBL {
    
    func doLoginWith(username:String,key:String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getLogin.rawValue)
        obj._serviceURL = developer_API + "login?email=" + username + "&password=" + key //API Method
        obj.MethodNamee = "GET"
        obj.serviceName = ""
        var dataDict = [String:AnyObject]()
        dataDict["email"] = username as AnyObject?
        dataDict["password"] = key as AnyObject?
        obj.params = dataDict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            if data.count > 0
                            {
                                let userBo = UserBO()
                                for user in data
                                {
                                    if let user_id = user["user_id"] as? String
                                    {
                                        userBo.user_id = user_id
                                        OrbUserDefaults.setUserId(object: user_id)
                                    }
                                    if let name = user["name"] as? String
                                    {
                                        OrbUserDefaults.setName(object: name)
                                        userBo.name = name
                                    }
                                    if let email = user["email"] as? String
                                    {
                                        userBo.email = email
                                    }
                                    if let account_type = user["account_type"] as? String
                                    {
                                        userBo.account_type = account_type
                                    }
                                    if let video_views = user["video_views"] as? String
                                    {
                                        userBo.video_views = video_views
                                    }
                                    if let image_views = user["image_views"] as? String
                                    {
                                        userBo.image_views = image_views
                                    }
                                    if let max_image_views = user["max_image_views"] as? String
                                    {
                                        userBo.max_image_views = max_image_views
                                    }
                                    if let max_video_views = user["max_video_views"] as? String
                                    {
                                        userBo.max_video_views = max_video_views
                                    }
                                    if let dailyViews = user["dailyViews"] as? String
                                    {
                                        userBo.dailyViews = dailyViews
                                    }
                                    if let dailyImgRem = user["dailyImgRem"] as? String
                                    {
                                        userBo.dailyImgRem = dailyImgRem
                                    }
                                    if let dailyVidViews = user["dailyVidViews"] as? String
                                    {
                                        userBo.dailyVidViews = dailyVidViews
                                    }
                                    if let dailyVidRem = user["dailyVidRem"] as? String
                                    {
                                        userBo.dailyVidRem = dailyVidRem
                                    }
                                    if let contactNo = user["contactNo"] as? String
                                    {
                                        userBo.contactNo = contactNo
                                        OrbUserDefaults.setMobile(object: contactNo)
                                    }
                                    if let alternativeNo = user["alternativeNo"] as? String
                                    {
                                        userBo.alternativeNo = alternativeNo
                                    }
                                    if let address = user["address"] as? String
                                    {
                                        userBo.address = address
                                    }
                                    if let payment_money = user["payment_money"] as? String
                                    {
                                        userBo.payment_money = payment_money
                                    }
                                    if let due_date = user["due_date"] as? String
                                    {
                                        userBo.due_date = due_date
                                    }
                                }
                                self.callBack.parsingFinished(userBo as AnyObject, withTag: obj.tag)
                            }
                            else
                            {
                                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                            }
                            
                        }
                        else
                        {
                            self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                            
                        }

                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)

                    }
                }
            }
        }
    }
    func forgotPasswordWith(email:String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.forgotPassword.rawValue)
        obj._serviceURL = developer_API + "forgotpass"
        obj.MethodNamee = "POST"
        obj.serviceName = ""
        var dataDict = [String:AnyObject]()
        dataDict["email"] = email as AnyObject?
        obj.params = dataDict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        self.callBack.parsingFinished("Success" as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
            }
        }
    }
    
    func getUserData()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getUserData.rawValue)
        obj._serviceURL = developer_API + "userdata/clientid=" + OrbUserDefaults.getUserId() //API Method
        obj.MethodNamee = "GET"
        obj.serviceName = ""
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        let homeData = HomeData()
                        if let lastFifteenMins = obj.parsedDataDict["lastFifteenMins"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = lastFifteenMins["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = lastFifteenMins["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let Today = obj.parsedDataDict["Today"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = Today["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = Today["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let Yesterday = obj.parsedDataDict["Yesterday"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = Yesterday["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = Yesterday["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let lastThirtyDays = obj.parsedDataDict["lastThirtyDays"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = lastThirtyDays["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = lastThirtyDays["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let PresentMonth = obj.parsedDataDict["PresentMonth"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = PresentMonth["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = PresentMonth["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let PastMonth = obj.parsedDataDict["PastMonth"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = PastMonth["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = PastMonth["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let PastTwoMonths = obj.parsedDataDict["PastTwoMonths"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let ImageCount = PastTwoMonths["ImageCount"] as? String
                            {
                                bo.imageCount = ImageCount
                            }
                            if let VideoCount = PastTwoMonths["VideoCount"] as? String
                            {
                                bo.videoCount = VideoCount
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let BannerClicks = obj.parsedDataDict["BannerClicks"] as? [String:AnyObject]
                        {
                            let bo = OverviewBO()
                            if let lastThirtyDays = BannerClicks["lastThirtyDays"] as? String
                            {
                                bo.imageCount = lastThirtyDays
                            }
                            homeData.arrOverView.append(bo)
                        }
                        if let Reports = obj.parsedDataDict["Reports"] as? [String:AnyObject]
                        {
                            if let Image = Reports["Image"] as? [[String:AnyObject]]
                            {
                                for data in Image
                                {
                                    let bo = ChartData()
                                    if let itc = data["itc"] as? String
                                    {
                                        bo.count = itc
                                    }
                                    if let day = data["day"] as? String
                                    {
                                        bo.date = day
                                    }
                                    homeData.arrImage.append(bo)
                                }
                            }
                            if let Video = Reports["Video"] as? [[String:AnyObject]]
                            {
                                for data in Video
                                {
                                    let bo = ChartData()
                                    if let vtc = data["vtc"] as? String
                                    {
                                        bo.count = vtc
                                    }
                                    if let day = data["day"] as? String
                                    {
                                        bo.date = day
                                    }
                                    homeData.arrVideo.append(bo)
                                }
                                
                            }
                            if let BannerClicks = Reports["BannerClicks"] as? [[String:AnyObject]]
                            {
                                for data in BannerClicks
                                {
                                    let bo = ChartData()
                                    if let btc = data["btc"] as? String
                                    {
                                        bo.count = btc
                                    }
                                    if let day = data["day"] as? String
                                    {
                                        bo.date = day
                                    }
                                    homeData.arrBanner.append(bo)
                                }
                                
                            }
                            if let Leads = Reports["Leads"] as? [[String:AnyObject]]
                            {
                                for data in Leads
                                {
                                    if let MobileNo = data["MobileNo"] as? String
                                    {
                                        homeData.arrLeads.append(MobileNo)
                                    }
                                }
                            }
                            
                        }
                        
                        self.callBack.parsingFinished(homeData as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
            }
        }
    }
    func getUserAds()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getUserAds.rawValue)
        obj._serviceURL = developer_API + "userads/clientid=" + OrbUserDefaults.getUserId() //API Method
        obj.MethodNamee = "GET"
        obj.serviceName = ""
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        let userAds = UserAdsBO()
                        if let video = obj.parsedDataDict["video"] as? [String:AnyObject]
                        {
                            if let video_thumbnail = video["video_thumbnail"] as? String
                            {
                                userAds.video_thumbnail = video_thumbnail
                            }
                            if let video_ad = video["video_ad"] as? String
                            {
                                userAds.video_ad = video_ad
                            }
                            if let Status = video["Status"] as? String
                            {
                                userAds.video_Status = Status
                            }
                        }
                        if let imageAd = obj.parsedDataDict["imageAd"] as? [String:AnyObject]
                        {
                            if let banner_ad_url = imageAd["banner_ad_url"] as? String
                            {
                                userAds.banner_ad_url = banner_ad_url
                            }
                            if let full_ad_url = imageAd["full_ad_url"] as? String
                            {
                                userAds.full_ad_url = full_ad_url
                            }
                            if let Status = imageAd["Status"] as? String
                            {
                                userAds.banner_Status = Status
                            }
                        }
                        if let shareLink = obj.parsedDataDict["shareLink"] as? [String:AnyObject]
                        {
                            if let Content = shareLink["Content"] as? String
                            {
                                userAds.shareLink_Content = Content
                            }
                            if let Link = shareLink["Link"] as? String
                            {
                                userAds.shareLink_Link = Link
                            }
                            if let PreviousURL = shareLink["PreviousURL"] as? String
                            {
                                userAds.shareLink_PreviousURL = PreviousURL
                            }
                        }

                        if let Text = obj.parsedDataDict["Text"] as? [String:AnyObject]
                        {
                            if let default1 = Text["default1"] as? String
                            {
                                userAds.Text_default1 = default1
                            }
                            if let default2 = Text["default2"] as? String
                            {
                                userAds.Text_default2 = default2
                            }
                        }

                        self.callBack.parsingFinished(userAds as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
            }
        }
    }
    func reqCallbackWith(subject:String,msg:String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getLogin.rawValue)
        obj._serviceURL = developer_API + "callback"
        obj.MethodNamee = "POST"
        obj.serviceName = ""
        var dataDict = [String:AnyObject]()
        dataDict["clientid"] = OrbUserDefaults.getUserId() as AnyObject?
        dataDict["mobileno"] = OrbUserDefaults.getMobile() as AnyObject?
        dataDict["subject"] = subject as AnyObject?
        dataDict["message"] = msg as AnyObject?
        obj.params = dataDict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        self.callBack.parsingFinished("Success" as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
            }
        }
    }
    func getLeads()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getLeads.rawValue)
        obj._serviceURL = developer_API + "leads/clientid=" + OrbUserDefaults.getUserId()
        obj.MethodNamee = "GET"
        obj.serviceName = ""
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        var arrLeads = [String]()
                        if let Leads = obj.parsedDataDict["Leads"] as? [[String:AnyObject]]
                        {
                            for lead in Leads
                            {
                                if let MobileNo = lead["MobileNo"] as? String
                                {
                                    arrLeads.append(MobileNo)
                                }
                            }
                        }
                        self.callBack.parsingFinished(arrLeads as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
            }
        }
        
    }
    func updateShareLinkWith(content:String,link:String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.updateShareLink.rawValue)
        obj._serviceURL = developer_API + "sharelinkupdate"
        obj.MethodNamee = "POST"
        obj.serviceName = ""
        var dataDict = [String:AnyObject]()
        dataDict["link"] = link as AnyObject?
        dataDict["content"] = content as AnyObject?
        dataDict["clientid"] = OrbUserDefaults.getUserId() as AnyObject?
        obj.params = dataDict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        self.callBack.parsingFinished("Success" as AnyObject, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
            }
        }
    }

    func uploadWith(data : Data,dataType:String,fileName : String,contentType:String,uploadString:String)
    {
        
            let tag = ParsingConstant.uploadImage.rawValue
            let strUrl : String = developer_API + uploadString as String
            let webStringURL = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            var request  = URLRequest(url: URL(string:webStringURL)!)
            request.httpMethod = "POST"
            let boundary = "Orb"
            let body = NSMutableData()
            body.append(("--\(boundary)\r\n").data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"clientid\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(OrbUserDefaults.getUserId())\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append(("--\(boundary)\r\n").data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(dataType)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: contentType\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            let content:String = "multipart/form-data; boundary=\(boundary)"
            request.setValue(content, forHTTPHeaderField: "Content-Type")
            request.setValue("\(body.length)", forHTTPHeaderField:"Content-Length")
            request.httpBody = body as Data?
            request.url = URL(string: webStringURL)!
            let config = URLSessionConfiguration.ephemeral
            config.timeoutIntervalForRequest = 40.0
            config.timeoutIntervalForResource = 40.0
            let session = URLSession(configuration: config)
        
            let task = session.dataTask(with: request) { (data, response, err) in
                if data != nil
                {
                    let dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    print("data string = ", dataString! as String)
                    if dataString != ""
                    {
                        
                        if self.convertStringToDictionary(dataString!) != nil
                        {
                            
                            let parsedDataDict = self.convertStringToDictionary(dataString!)! as [String:AnyObject]
                            if parsedDataDict.keys.count == 0
                            {
                                self.callBack.parsingError(SERVER_ERROR, withTag: tag)
                            }
                            else
                            {
                                if let error = parsedDataDict["error"] as? String
                                {
                                    if Bool(error) == false
                                    {
                                        if let message = parsedDataDict["message"] as? String
                                        {
                                            self.callBack.parsingFinished(message as AnyObject, withTag: tag)
                                        }
                                        else
                                        {
                                            self.callBack.parsingError(SERVER_ERROR, withTag: tag)
                                        }
                                    }
                                    else
                                    {
                                        self.callBack.parsingError(SERVER_ERROR, withTag: tag)
                                    }
                                }
                            }
                            
                        }
                        else
                        {
                            self.callBack.parsingError(SERVER_ERROR, withTag: tag)
                        }
                        
                        
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: tag)
                    }

                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: tag)

                }
                
                
            }
            
            task.resume()
    
    }
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func encodeSpecialCharactersManually(_ strParam : String)-> String
    {
        
        var strParams = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        strParams = strParams!.replacingOccurrences(of: "&", with:"%26")
        return strParams!
    }
    
    
    func convertSpecialCharactersFromStringForAddress(_ strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of: "&", with:"&amp;")
        strParams = strParams.replacingOccurrences(of: ">", with: "&gt;")
        strParams = strParams.replacingOccurrences(of: "<", with: "&lt;")
        strParams = strParams.replacingOccurrences(of: "\"", with: "&quot;")
        strParams = strParams.replacingOccurrences(of: "'", with: "&apos;")
        return strParams
    }
    
    
    func convertStringFromSpecialCharacters(strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of:"%26", with:"&")
        strParams = strParams.replacingOccurrences(of:"&amp;", with:"&")
        strParams = strParams.replacingOccurrences(of:"%3E", with: ">")
        strParams = strParams.replacingOccurrences(of:"%3C" , with: "<")
        strParams = strParams.replacingOccurrences(of:"&quot;", with: "\"")
        strParams = strParams.replacingOccurrences(of:"&apos;" , with: "'")
        
        return strParams
    }
    
    
}


