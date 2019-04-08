//
//  SHttpRequest.swift
//  HumaraShop
//
//  Created by  on 05/11/15.
//  Copyright © 2015 Mery. All rights reserved.
//

import Foundation

@objc protocol HHandlerDelegate
{
    @objc optional func completedWithDictionary (dictTemp : NSDictionary)
    @objc optional func errorOccuredWithError(strError:NSString, strTag:NSString)
}
      let PublicKey = "NFEOCBUT"  //4Fingers
      let SecretKey  = "FLIATMXBJEAAP2E7EPTDVI2A&" //4Fingers



class HttpRequest
{
    let contentType = "application/x-www-form-urlencoded"
    let methodName = "POST"
    let GETMethod = "GET"
    var api_version : String = ""
    var serviceName: String = ""
    var _serviceURL: String = ""
    var MethodNamee: String = ""
    var ServiceBody: String = ""
    var tag: NSInteger
    var params = [String:AnyObject]()
    var headerDict : [String:AnyObject]!
    var parsedDataDict : [String:AnyObject]!
    let api_key = "api_key"
    init()
    {
        tag = 0
    }
    func ServiceName(_ serviceURL : String, params:[String:AnyObject])
    {
        var serviceName: String {
            get {
                return self.serviceName
            }
            set {
                self.serviceName = serviceURL
            }
        }
        var params: [String:AnyObject] {
            get {
                return self.params
            }
            set {
                self.params = params
            }
        }
    }
    
    func doGetSOAPResponse ( _ completion: @escaping (_ result: Bool) -> Void)
    {
        var requestBody:Data?
        var strUrl : String = _serviceURL as String
        
        if params.count > 0
        {
            requestBody = self.doPrepareSOAPEnvelope().data(using: String.Encoding.utf8.rawValue)
        }
        if serviceName.count > 0
        {
            strUrl = strUrl + "/" + serviceName
        }
        let webStringURL = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        var request  = URLRequest(url: URL(string:webStringURL)!)
        request.httpMethod = MethodNamee
        if api_version != ""{
            request.setValue(api_version, forHTTPHeaderField: "APIVersion")
        }
        request.httpBody = requestBody as Data?
        request.url = URL(string: webStringURL)!
        print("url = " + "\(request.url)")
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 40.0
        config.timeoutIntervalForResource = 40.0
        let session = URLSession(configuration: config)
        if self.tag != ParsingConstant.getLogin.rawValue && self.tag != ParsingConstant.forgotPassword.rawValue
        {
            request.setValue("Bearer " + OrbUserDefaults.getAccessToken(), forHTTPHeaderField: "Authorization")
        }

        let task = session.dataTask(with: request) { (data, response, err) in
            if data != nil
            {
                let dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("data string = ", dataString! as String)
                print("service URL = ", self._serviceURL)
                if dataString != ""
                {
                    
                    if self.convertStringToDictionary(dataString!) != nil
                    {
                        
                        self.parsedDataDict = self.convertStringToDictionary(dataString!)! as [String:AnyObject]
                        if self.parsedDataDict.keys.count == 0
                        {
                            completion (false)
                        }
                        else
                        {
                            completion (true)
                        }
                        
                    }
                    else
                    {
                        self.parsedDataDict = [:]
                        completion (false)
                    }
                    
                    
                }
                else
                {
                    completion(false)
                }
            }
            else
            {
                completion(false)
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
                return [:]
            }
        }
        return nil
    }
    
    func doPrepareSOAPEnvelope() ->NSMutableString
    {
        let soapEnvelope :NSMutableString? = NSMutableString()
        let keys  = self.params.keys
        let allKey : Int = self.params.count
        if allKey > 0
        {
            
            soapEnvelope?.appendFormat("%@=%@", keys.first! , self.params[keys.first!] as! String)
            
            
            for i in 1 ..< allKey {
                
                let object : AnyObject = self.params[Array(keys)[i]]! as AnyObject;
                
                if object is NSString
                {
                    soapEnvelope?.appendFormat("&%@=%@", Array(keys)[i],self.params[Array(keys)[i]] as! String)
                    
                }
                else if object is NSMutableArray
                {
                    do {
                        let jsonData2 : Data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let datastring = NSString(data: jsonData2, encoding: UInt())
                    
                        soapEnvelope?.appendFormat("&%@=%@", Array(keys)[i],datastring!)
                        
                        // use jsonData
                    } catch {
                        // report error
                    }
                    
                    
                }
                
            }
            print(soapEnvelope!)
        }
        
        return soapEnvelope!
    }
}
