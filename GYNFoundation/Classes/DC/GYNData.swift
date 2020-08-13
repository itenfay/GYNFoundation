//
//  GYNData.swift
//
//  Created by dyf on 16/2/15. ( https://github.com/dgynfi/GYNFoundation )
//  Copyright © 2016 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

class GYNData: NSObject, GYNDataGAReporterDelegate {
    
    public static let shared = GYNData()
    
    var version: String {
        return "3.0.2"
    }
    
    var debug: Bool = false
    var enabledLog: Bool = false
    var beginTime: Int = 0
    var statKey: String = ""
    var uuid: String? = ""
    var loginStatus: Bool = false
    
    var url: String?
    var uid: String?
    var collectedData: NSMutableDictionary?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(GYNData.enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GYNData.enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
            trackActivatedBehavior()
        }
    }
    
    @objc func timerAction() {
        self.count += 1
        
        GYNLog("count: \(count)")
        
        if count == 30 {
            trackSuspendedBehavior()
        }
    }
    
    private func getParameters(eventID id: UInt8) -> String {
        let data = GYNDataUtils.baseData() as! NSMutableDictionary
        
        data.setValue(String(id), forKey: "eventId")
        
        if collectedData != nil {
            for key in collectedData!.allKeys {
                let k = key as! String
                let value = collectedData?.value(forKey: k)
                data.setValue(value, forKey: k)
            }
        }
        
        let jsonArray: String = GYNDataUtils.jsonArray(withObject: data)!
        GYNLog("[p] " + jsonArray)
        
        let timeStamp: Int = GYNDataUtils.timeStamp()
        
        let str: String = String(format: "dataJsonArray=%@&time=%d&key=%@", jsonArray, timeStamp, self.statKey)
        let hash = str.md5 ?? ""
        
        return String(format: "dataJsonArray=%@&time=%d&hash=%@", jsonArray, timeStamp, hash)
    }
    
    func onTrack(eventID id: UInt8) {
        let args = getParameters(eventID: id)
        
        let reporter = GYNDataGAReporter()
        self.objects.add(reporter)
        
        reporter.eventID = id
        reporter.delegate = self
        reporter.report(url: self.url ?? "", args: args)
    }
    
    func onResponse(reporter: GYNDataGAReporter, error: NSError?) {
        GYNLog("Event.id: \(reporter.eventID)")
        
        if let err = error {
            GYNLog("Event.error: \(err)")
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
    
    private func trackActivatedBehavior() {
        if self.count < 30 {
            
            endBackgroundTask()
        } else {
            let userID: String? = self.uid
            self.beginTime = GYNDataUtils.timeStamp()
            
            collectedData = NSMutableDictionary()
            
            collectedData?.setValue(self.uuid, forKey: "deviceId")
            collectedData?.setValue(userID ?? self.uuid, forKey: "userId")
            collectedData?.setValue(GYNSettings.default.basicConf.appID, forKey: "appId")
            collectedData?.setValue(GYNSettings.default.basicConf.cpID, forKey: "cpId")
            collectedData?.setValue(GYNSettings.default.basicConf.channelID, forKey: "channelId")
            
            onTrack(eventID: GYNDataGAEventID.activate.rawValue)
        }
        
        self.count = 0
    }
    
    private func trackSuspendedBehavior() {
        let userID: String? = self.uid
        let timeStamp = labs(GYNDataUtils.timeStamp() - self.beginTime)
        
        collectedData = NSMutableDictionary()
        
        collectedData?.setValue(self.uuid, forKey: "deviceId")
        collectedData?.setValue(userID ?? self.uuid, forKey: "userId")
        collectedData?.setValue(String(timeStamp), forKey: "num")
        collectedData?.setValue(GYNSettings.default.basicConf.appID, forKey: "appId")
        collectedData?.setValue(GYNSettings.default.basicConf.cpID, forKey: "cpId")
        collectedData?.setValue(GYNSettings.default.basicConf.channelID, forKey: "channelId")
        
        onTrack(eventID: GYNDataGAEventID.suspend.rawValue)
    }
    
}
