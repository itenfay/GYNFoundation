//
//  AppDelegate.swift
//
//  Created by dyf on 16/2/3.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GYNSettings.default.debug      = true
        GYNSettings.default.enabledLog = true
        
        let deviceID = GYNDevice.deviceID()
        GYNDataGA.setDebugMode(GYNSettings.default.debug)
        GYNDataGA.setEnabledLog(GYNSettings.default.enabledLog)
        GYNDataGA.setDeviceID(deviceID)
        
        GYNDataGA.setStatKey("BC070542FFAGPOJKL")
        GYNDataGA.setUrl("https://xpay.nyg.com/statdata/collect")
        
        GYNSettings.default.basicConf.appID        = "68"
        GYNSettings.default.basicConf.cpID         = "10"
        GYNSettings.default.basicConf.cpName       = "Mucheng"
        GYNSettings.default.basicConf.channelID    = "4"
        GYNSettings.default.basicConf.channelName  = "appstore"
        GYNSettings.default.basicConf.currencyCode = "CNY"
        GYNSettings.default.basicConf.noticeUrl    = "http://xpay.nyg.com/api/notice"
        
        self.perform(#selector(AppDelegate.trackLaunchedBehavior), with: nil, afterDelay: 1.0)
        
        return true
    }
    
    @objc func trackLaunchedBehavior() {
        GYNDataGA.setBeginTime(GYNDataUtils.timeStamp())
        
        let data = GYNKVAdapter()
        
        data.setValue(GYNDataGA.deviceID(), forKey: "userId")
        data.setValue("DFAfS301452094AfDBfHIHERQ", forKey: "token")
        
        data.setValue(GYNSettings.default.basicConf.appID, forKey: "appId")
        data.setValue(GYNSettings.default.basicConf.cpID, forKey: "cpId")
        data.setValue(GYNSettings.default.basicConf.channelID, forKey: "channelId")
        
        GYNDataGA.onTrack(eventID: GYNDataGAEventID.launch, data: data)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

