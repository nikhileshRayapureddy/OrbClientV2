//
//  UserDefaults.swift
//  OrbClient
//
//  Created by Nikhilesh on 18/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit
let  UserNameKey = "Username"
let  NameKey = "Name"
let  KeyWord = "KeyWord"
let  Mobile = "Mobile"
let  isRemember = "isRemember"
let  isAddAgency = "isAddAgency"
class OrbUserDefaults: NSObject {
    class func setUserName (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserNameKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserName () -> String
    {
        return UserDefaults.standard.object(forKey: UserNameKey) as! String
    }
    class func setName (object : String)
    {
        UserDefaults.standard.set(object, forKey: NameKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getName () -> String
    {
        return UserDefaults.standard.object(forKey: NameKey) as! String
    }
    class func setMobile (object : String)
    {
        UserDefaults.standard.set(object, forKey: Mobile)
        UserDefaults.standard.synchronize()
    }
    
    class func getMobile () -> String
    {
        return UserDefaults.standard.object(forKey: Mobile) as! String
    }

    class func setKeyWord (object : String)
    {
        UserDefaults.standard.set(object, forKey: KeyWord)
        UserDefaults.standard.synchronize()
    }
    
    class func getKeyWord () -> String
    {
        return UserDefaults.standard.object(forKey: KeyWord) as! String
    }
    class func setUserId (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserNameKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserId () -> String
    {
        return UserDefaults.standard.object(forKey: UserNameKey) as! String
    }
    
    class func setLoginStatus (object : String)
    {
        UserDefaults.standard.set(object, forKey: isRemember)
        UserDefaults.standard.synchronize()
    }

    class func getLoginStatus () -> String
    {
        if UserDefaults.standard.object(forKey: isRemember) as? String == nil
        {
            return "false"
        }
        else
        {
            return UserDefaults.standard.object(forKey: isRemember) as! String

        }
    }
    class func getIsAddAgency() -> Bool{
        return UserDefaults.standard.bool(forKey:isAddAgency)
    }
    class func setIsAddAgency(object:Bool)
    {
        UserDefaults.standard.set(object, forKey: isAddAgency)
        UserDefaults.standard.synchronize()
        
    }


}
