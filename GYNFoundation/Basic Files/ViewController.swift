//
//  ViewController.swift
//
//  Created by dyf on 16/2/3.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

fileprivate let uid: String = "301452094"

class ViewController: UIViewController {
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 20, y: 50, width: 160, height: 40)
        button.backgroundColor = UIColor.brown
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.showsTouchWhenHighlighted = true
        button.setTitle("Track Login", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(ViewController.trackLoginBehavior(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        let button1 = UIButton(type: UIButton.ButtonType.custom)
        button1.frame = CGRect(x: 20, y: 110, width: 160, height: 40)
        button1.backgroundColor = UIColor.brown
        button1.layer.cornerRadius = 5.0
        button1.layer.masksToBounds = true
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button1.showsTouchWhenHighlighted = true
        button1.setTitle("Print Data", for: UIControl.State.normal)
        button1.addTarget(self, action: #selector(ViewController.printData(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(type: UIButton.ButtonType.custom)
        button2.frame = CGRect(x: 20, y: 170, width: 160, height: 40)
        button2.backgroundColor = UIColor.brown
        button2.layer.cornerRadius = 5.0
        button2.layer.masksToBounds = true
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button2.showsTouchWhenHighlighted = true
        button2.setTitle("Show Tip", for: UIControl.State.normal)
        button2.addTarget(self, action: #selector(ViewController.showMessage(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button2)
        
        self.perform(#selector(ViewController.loadBackgroundView), with: nil, afterDelay: 0.2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let d = GYNSettings.default.debug ? "true" : "false"
        let l = GYNSettings.default.enabledLog ? "true" : "false"
        let deviceID = GYNDevice.deviceID()
        
        let msg = "debug: " + d + ", enabledLog: " + l + ", deviceID: " + deviceID
        GYNLog("msg: \(msg)")
    }
    
    @objc func trackLoginBehavior(_ button: UIButton) {
        GYNDataGA.setBeginTime(GYNDataUtils.timeStamp())
        GYNDataGA.setLoginStatus(true)
        
        let data = GYNKVAdapter()
        
        data.setValue(uid, forKey: "userId")
        data.setValue("DFAfS301452094AfDBfHIHERQ", forKey: "token")
        
        data.setValue(GYNSettings.default.basicConf.appID, forKey: "appId")
        data.setValue(GYNSettings.default.basicConf.cpID, forKey: "cpId")
        data.setValue(GYNSettings.default.basicConf.channelID, forKey: "channelId")
        
        GYNDataGA.onTrack(eventID: GYNDataGAEventID.login, data: data)
    }
    
    @objc func printData(_ button: UIButton) {
        self.showLoading("正在打印数据...")
        
        GYNProduct.name = "60 Coins"
        GYNProduct.price = GYNUtils.number(withDouble: 6.0)
        GYNProduct.mark = "mark"
        
        let adapter = GYNUtils.adapter()
        adapter.setValue("2017022023423980", forKey: "transId")
        adapter.setValue(GYNSettings.default.basicConf.noticeUrl, forKey: "noticeUrl")
        adapter.setValue("74", forKey: "serverId")
        adapter.setValue("The Source Of Power", forKey: "serverName")
        adapter.setValue(uid, forKey: "userId")
        adapter.setValue(GYNDataGA.deviceID(), forKey: "deviceId")
        adapter.setValue(GYNEmptyString, forKey: "channelTransId")
        adapter.setValue(GYNSettings.default.basicConf.cpID, forKey: "cpId")
        adapter.setValue(GYNSettings.default.basicConf.cpName, forKey: "cpName")
        adapter.setValue(GYNSettings.default.basicConf.appID, forKey: "appId")
        adapter.setValue(GYNSettings.default.basicConf.channelID, forKey: "channelId")
        adapter.setValue(GYNSettings.default.basicConf.appName, forKey: "appName")
        adapter.setValue(GYNSettings.default.basicConf.channelName, forKey: "pubChannel")
        adapter.setValue(GYNProduct.name, forKey: "goodsName")
        adapter.setValue(GYNProduct.price, forKey: "amount")
        adapter.setValue(GYNProduct.mark, forKey: "markMsg")
        adapter.setValue(GYNSettings.default.basicConf.currencyCode, forKey: "currency")
        GYNLog("adapter: \(adapter)")
        
        let json = GYNUtils.json(withObject: adapter)
        GYNLog("json: \(json ?? "")")
        
        let bundlePath = GYNUtils.bundlePath(withName: kDefaultBundleName) ?? ""
        let defaultFilePath = GYNUtils.defaultFilePath()
        GYNLog("bundlePath: \(bundlePath), defaultFilePath: \(defaultFilePath)")
        
        let defaultDict = NSDictionary(contentsOfFile: defaultFilePath)
        let defaultJson = GYNUtils.json(withObject: defaultDict)
        GYNLog("defaultJson: \(defaultJson ?? "")")
        
        self.hideLoading()
    }
    
    @objc func showMessage(_ button: UIButton) {
        GYNLog("appVersion: \(appVersion() ?? "")")
        self.showTipsMessage("The test is OK.")
    }
    
    @objc func loadBackgroundView() {
        self.showLoading(" Loading... ")
        
        let frame = CGRect(x: self.view.frame.origin.x,
                           y: self.view.frame.origin.y,
                           width: self.view.bounds.width,
                           height: self.view.bounds.height)
        self.imageView = UIImageView(frame: frame)
        self.imageView!.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleLeftMargin.rawValue |
            UIView.AutoresizingMask.flexibleTopMargin.rawValue  |
            UIView.AutoresizingMask.flexibleWidth.rawValue      |
            UIView.AutoresizingMask.flexibleHeight.rawValue
        )
        self.imageView!.contentMode = .scaleAspectFill
        self.view.addSubview(self.imageView!)
        self.view.sendSubviewToBack(self.imageView!)
        
        /*
        let url = URL(string: "http://www.51pptmoban.com/d/file/2014/05/13/d12562dabc94ff6130521134133b5d3d.jpg")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!, options: Data.ReadingOptions.mappedIfSafe)
            if data != nil {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.imageView?.image = image
                }
            }
        }
         */
        
        self.execute()
    }
    
    func execute() {
        let aUrl: String = "http://www.pptbz.com/pptpic/UploadFiles_6909/201206/2012062620093440.jpg"
        let url: URL? = URL(string: aUrl)!
        let httpClient = GYNHttpClient(url: url, method: .Get)
        
        httpClient.sendAsyncRequest {
            (response: URLResponse?,
            data: Any?,
            error: NSError?) in
            
            let httpUrlResponse = response as? HTTPURLResponse
            
            if let r = httpUrlResponse, r.statusCode == GYNURLNoError {
                
                if data != nil {
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data: data as! Data)
                    }
                }
            } else {
                
                if error != nil {
                    GYNLog("Error: \(error!)")
                }
            }
            
            DispatchQueue.main.async {
                self.hideLoading()
            }
            
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
