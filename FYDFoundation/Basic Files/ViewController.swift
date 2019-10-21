//
//  ViewController.swift
//
//  Created by dyf on 16/2/3.
//  Copyright © 2016 dyf. All rights reserved.
//

import UIKit

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

public let uid: String = "301452094"

class ViewController: UIViewController {
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        FYDSettings.default.debug      = true
        FYDSettings.default.enabledLog = true
        
        FYDBasicConfiguration.default.appId        = "68"
        FYDBasicConfiguration.default.cpId         = "10"
        FYDBasicConfiguration.default.cpName       = "Mucheng"
        FYDBasicConfiguration.default.channelId    = "4"
        FYDBasicConfiguration.default.channelName  = "appstore"
        FYDBasicConfiguration.default.currencyCode = "CNY"
        
        FYDDataGA.onDebugMode(FYDSettings.default.debug)
        FYDDataGA.onEnableLog(FYDSettings.default.enabledLog)
        FYDDataGA.setDeviceId(FYDDevice.deviceId())
        FYDDataGA.setStatKey("BC070542FFAGPOJKL")
        FYDDataGA.setUrl("https://eso.fyd.com/tg/data/collect")
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 20, y: 50, width: 160, height: 40)
        button.backgroundColor = UIColor.brown
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.showsTouchWhenHighlighted = true
        button.setTitle("统计登录", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(ViewController.statLogin(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        let button1 = UIButton(type: UIButton.ButtonType.custom)
        button1.frame = CGRect(x: 20, y: 110, width: 160, height: 40)
        button1.backgroundColor = UIColor.brown
        button1.layer.cornerRadius = 5.0
        button1.layer.masksToBounds = true
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button1.showsTouchWhenHighlighted = true
        button1.setTitle("打印数据", for: UIControl.State.normal)
        button1.addTarget(self, action: #selector(ViewController.printData(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(type: UIButton.ButtonType.custom)
        button2.frame = CGRect(x: 20, y: 170, width: 160, height: 40)
        button2.backgroundColor = UIColor.brown
        button2.layer.cornerRadius = 5.0
        button2.layer.masksToBounds = true
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button2.showsTouchWhenHighlighted = true
        button2.setTitle("提示", for: UIControl.State.normal)
        button2.addTarget(self, action: #selector(ViewController.showTipMessage(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button2)
        
        self.loadBackgroundView()
    }
    
    @objc func statLogin(_ button: UIButton) {
        FYDDataGA.setBeginTime(FYDDataUtils.timeStamp())
        FYDDataGA.setLoginStatus(true)
        
        let data = NSMutableDictionary()
        data.setValue(uid, forKey: "userId")
        data.setValue("DFAfS301452094AfDBfHIHERQ", forKey: "token")
        
        FYDDataGA.onTrack(eventId: FYDDataGAEventId.FYD_GA_Event_Login.rawValue, data: data)
    }
    
    @objc func printData(_ button: UIButton) {
        FYDProduct.name = "60金币"
        FYDProduct.price = FYDUtils.number(withDouble: 6.0)
        FYDProduct.mark = "mark"
        
        let adapter = FYDUtils.adapter()
        adapter.setValue("2017022023423980", forKey: "transId")
        adapter.setValue("http://dot.pay.fy.com/api/fy", forKey: "noticeUrl")
        adapter.setValue("74", forKey: "serverId")
        adapter.setValue("圣骑之士", forKey: "serverName")
        adapter.setValue(uid, forKey: "userId")
        adapter.setValue(FYDDevice.deviceId(), forKey: "deviceId")
        adapter.setValue(FYDEmptyString, forKey: "channelTransId")
        adapter.setValue(FYDBasicConfiguration.default.cpId, forKey: "cpId")
        adapter.setValue(FYDBasicConfiguration.default.cpName, forKey: "cpName")
        adapter.setValue(FYDBasicConfiguration.default.appId, forKey: "appId")
        adapter.setValue(FYDBasicConfiguration.default.appName, forKey: "appName")
        adapter.setValue(FYDBasicConfiguration.default.channelId, forKey: "channelId")
        adapter.setValue(FYDBasicConfiguration.default.channelName, forKey: "pubChannel")
        adapter.setValue(FYDProduct.name, forKey: "goodsName")
        adapter.setValue(FYDProduct.price, forKey: "amount")
        adapter.setValue(FYDProduct.mark, forKey: "markMsg")
        adapter.setValue(FYDBasicConfiguration.default.currencyCode, forKey: "currency")
        
        FYDLog("adapter: %@", adapter)
        
        let json = FYDUtils.json(withObject: <#T##Any?#>)
        FYDLog("json: %@", json ?? "")
        
        let fileInfo = FYDFetcher.default.specifiedFileInfo()
        FYDLog("fileInfo: %@", fileInfo ?? "")
    }
    
    @objc func showTipMessage(_ button: UIButton) {
        FYDLog("%@", appVersion() ?? "")
        FYDProgressHud.default.showTip(view: self.view, text: "提示了！")
    }
    
    func loadBackgroundView() {
        FYDProgressHud.default.showCustomSpinner(view: self.view, text: "正在加载背景")
        
        let frame = CGRect(x: self.view.frame.origin.x,
                           y: self.view.frame.origin.y,
                           width: self.view.bounds.width,
                           height: self.view.bounds.height)
        self.imageView = UIImageView(frame: frame)
        
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
        let httpClient = FYDHttpClient(url: url, method: .Get)
        
        httpClient.sendAsyncRequest {
            (response: URLResponse?,
            data: Any?,
            error: NSError?) in
            
            let httpUrlResponse = response as? HTTPURLResponse
            
            if let r = httpUrlResponse, r.statusCode == FYDURLNoError {
                
                if data != nil {
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data: data as! Data)
                    }
                }
            } else {
                
                if error != nil {
                    FYDLog("Error: \(error!)")
                }
            }
            
            DispatchQueue.main.async {
                if FYDProgressHud.default.hasHud() {
                    FYDProgressHud.default.hide()
                }
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
        return UIInterfaceOrientationMask.landscape
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let rect = UIScreen.main.bounds
        let sysVersion = Double(UIDevice.current.systemVersion)
        if toInterfaceOrientation.isLandscape {
            if sysVersion < 8.0 {
                self.imageView?.frame = CGRect(x: 0, y: 0, width: rect.height, height: rect.width)
            } else {
                self.imageView?.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            }
        } else {
            self.imageView?.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

