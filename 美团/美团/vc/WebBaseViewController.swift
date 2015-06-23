//
//  WebBaseViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/16.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit


class WebBaseViewController: UIViewController {
    var bridge: WebViewJavascriptBridge!
    var url = ""
    var myWebView:UIWebView?
    var qrCode:QRCodeHelper?
    override func viewDidLoad() {
        super.viewDidLoad()

        WebViewJavascriptBridge.enableLogging()
        // Do any additional setup after loading the view.
        self.bridge = WebViewJavascriptBridge(forWebView: myWebView, handler: {
            data, responseCallback in
        })
        
        bridge.registerHandler("qr" ,handler: {
            data, responseCallback in
            //点击QR二维码

            func onScanTxt(txt:String!)->Void{
                let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
                responseCallback(jsonRes.object)
            }
            self.qrCode = QRCodeHelper()
            self.qrCode?.delegate = onScanTxt
            self.qrCode?.showView(self)

        })
        
        bridge.registerHandler("ras" ,handler: {
            data, responseCallback in
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().removeObserver(self)
                NSNotificationCenter.defaultCenter().postNotificationName("onLoginRefresh", object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginRefresh:", name: "onLoginRefresh", object: nil)
            })
            var txt:String! = "OK"
            let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
            responseCallback(jsonRes.object)
            
        })
        
        bridge.registerHandler("pp" ,handler: {
            data, responseCallback in

            let json = JSON(data)
            
            if let paramurl = json["param1"].string{
                println("recv json===>\(paramurl)")
                if let paramaction = json["param2"].string{
                    if paramaction == "self"{
                        self.url = paramurl
                        self.loadurl()
                        return
                    }
                    else if paramaction == "blank"{
                        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("webpageview") as! WebPageViewController
                        dvc.url  = paramurl
                        self.navigationController?.pushViewController(dvc, animated: true)
                        
                    }
                }
            }
            var txt:String! = "OK"
            let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
            responseCallback(jsonRes.object)
        })
        //--------------------------------------------------------------------
        bridge.registerHandler("gcl" ,handler: {
            data, responseCallback in
           
            var txt:String! = "不能获取坐标"
            LocationManager.getInstance().startMonitoringSignificantLocationChanges {
                (issuccess,location) -> () in
                dispatch_async(dispatch_get_main_queue(), {
                    LocationManager.getInstance().stopMonitoringSignificantLocationChanges()
                })
                
                var resultTxt:String!="failed"
                if issuccess {
                    txt = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
                    resultTxt = "success"
                    println("\(txt)")
                }
                
                let jsonRes = JSON(["type":"res","param1":resultTxt,"param2":txt])
                responseCallback(jsonRes.object)
            }
            
        })
        //--------------------------------------------------------------------
        //调用地图
        bridge.registerHandler("cmv" ,handler: {
            data, responseCallback in
            //MapViewController
            let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("mapview") as! MapViewController
            self.navigationController?.pushViewController(dvc, animated: true)
        })
       


        
        var btnTest = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnTest.frame = CGRectMake(0, 0, 64, 32);
        btnTest.setTitle("测试", forState: UIControlState.Normal)
        btnTest.addTarget(self, action: "onClickTest:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnTest)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginRefresh:", name: "onLoginRefresh", object: nil)
        self.navigationController?.navigationBarHidden = true
        
        loadurl()
//        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDel.curDetailView = self
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onLoginRefresh(notification: NSNotification){
        refreshPage()
    }
    
    func refreshPage(){
       // loadurl()
        println("refresh page:\(self.myWebView?.request!.URL!.absoluteString)")
        myWebView?.reload()
    }
    
    func onClickTest(sender: UIViewController) {
        var txt:String! = "这是个测试"
        let jsonRes = JSON(["type":"req","param1":"success","param2":txt])
        bridge.callHandler("calljs",data:jsonRes.object,responseCallback:{
            data  in
            let json = JSON(data)

            if let p2 = json["param2"].string{
                println("recv json===>\(p2)")
            }
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loadurl(){
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        myWebView?.loadRequest(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
