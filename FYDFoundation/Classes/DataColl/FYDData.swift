//
//  FYDData.swift
//
//  Created by dyf on 16/2/15.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

class FYDData: NSObject, FYDDataGAReporterDelegate {
    
    open class var shared: FYDData {
        struct Inner {
            static var instance: FYDData = FYDData()
        }
        return Inner.instance
    }
    
    var version: String {
        return "2.0"
    }
    
    var debug: Bool = false
    var enabledLog: Bool = false
    var beginTime: Int = 0
    var statKey: String = ""
    var udid: String?
    var loginStatus: Bool = false
    
    var url: String?
    var uid: String?
    var collectData: NSMutableDictionary?
    
    private var taskId: UIBackgroundTaskIdentifier?
    private var objects = NSMutableArray(capacity: 0)
    private var timer: Timer?
    private var count: UInt8 = 0
    
    private override init() {
        super.init()
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(FYDData.enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FYDData.enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func enterBackground() {
        if self.loginStatus {
            self.taskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                self.endBackgroundTask()
            })
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    @objc func enterForeground() {
        if self.loginStatus {
            executeActivate()
        }
    }
    
    @objc func timerAction() {
        self.count += 1
        FYDLog("count: \(count)")
        if count == 30 {
            executeSuspend()
        }
    }
    
    private func handleData(eventId id: UInt8) -> String {
        let data = FYDDataUtils.baseData() as! NSMutableDictionary
        data.setValue(String(id), forKey: "eventId")
        
        if collectData != nil {
            for key in collectData!.allKeys {
                let k = key as! String
                let value = collectData?.value(forKey: k)
                data.setValue(value, forKey: k)
            }
        }
        
        let jsonArray: String = FYDDataUtils.jsonArray(withObject: data)!
        FYDLog("[JArray] " + jsonArray)
        let timeStamp: Int = FYDDataUtils.timeStamp()
        let str: String = String(format: "dataJsonArray=%@&time=%d&key=%@", jsonArray, timeStamp, self.statKey)
        let hash = str.md5 ?? ""
        
        return String(format: "dataJsonArray=%@&time=%d&hash=%@", jsonArray, timeStamp, hash)
    }
    
    func onTrack(eventId id: UInt8) {
        let args: String = handleData(eventId: id)
        
        let reporter = FYDDataGAReporter()
        self.objects.add(reporter)
        
        reporter.eventId = id
        reporter.delegate = self
        reporter.report(url: self.url ?? "", args: args)
    }
    
    func onResponse(reporter: FYDDataGAReporter, error: NSError?) {
        FYDLog("Event.id: \(reporter.eventId)")
        if error != nil {
            FYDLog("Event.error: \(error!)")
        }
        self.objects.remove(reporter)
    }
    
    private func endBackgroundTask() {
        DispatchQueue.global().async {
            if self.timer != nil && self.timer!.isValid {
                self.timer!.invalidate()
                self.timer = nil
            }
            
            UIApplication.shared.endBackgroundTask(self.taskId!)
            self.taskId = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    private func executeActivate() {
        if self.count < 30 {
            
            endBackgroundTask()
        } else {
            let userId: String? = self.uid
            self.beginTime = FYDDataUtils.timeStamp()
            
            collectData = NSMutableDictionary()
            
            collectData?.setValue(self.udid, forKey: "deviceId")
            collectData?.setValue(userId ?? self.udid, forKey: "userId")
            collectData?.setValue(FYDBasicConfiguration.default.appId, forKey: "appId")
            collectData?.setValue(FYDBasicConfiguration.default.cpId, forKey: "cpId")
            collectData?.setValue(FYDBasicConfiguration.default.channelId, forKey: "channelId")
            
            onTrack(eventId: FYDDataGAEventId.FYD_GA_Event_Activate.rawValue)
        }
        
        self.count = 0
    }
    
    private func executeSuspend() {
        let userId: String? = self.uid
        let timeStamp = labs(FYDDataUtils.timeStamp() - self.beginTime)
        
        collectData = NSMutableDictionary()
        
        collectData?.setValue(self.udid, forKey: "deviceId")
        collectData?.setValue(userId ?? self.udid, forKey: "userId")
        collectData?.setValue(String(timeStamp), forKey: "num")
        collectData?.setValue(FYDBasicConfiguration.default.appId, forKey: "appId")
        collectData?.setValue(FYDBasicConfiguration.default.cpId, forKey: "cpId")
        collectData?.setValue(FYDBasicConfiguration.default.channelId, forKey: "channelId")
        
        onTrack(eventId: FYDDataGAEventId.FYD_GA_Event_Suspend.rawValue)
    }
    
}
