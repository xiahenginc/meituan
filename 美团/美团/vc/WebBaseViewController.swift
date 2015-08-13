//
//  WebBaseViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/16.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

typealias onQQAutologinResult = (JSON!) ->Void

class WebBaseViewController: UIViewController,TencentSessionDelegate {
    var bridge: WebViewJavascriptBridge!
    var url = ""
    var myWebView:UIWebView?
    var qrCode:QRCodeHelper?
    var _tencentOAuth:TencentOAuth?
    var qqautologinresult:onQQAutologinResult?
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
        bridge.registerHandler("alipaygrwhandler" ,handler: {
            data, responseCallback in
           
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.alipayResult = {
                jsonRes in
                responseCallback(jsonRes.object)
            }

            let json = JSON(data)
            if let orderinfo = json["param1"].string{
                
                AlipaySDK.defaultService().payOrder(orderinfo, fromScheme: "alipaygrw") { (result: [NSObject: AnyObject]!) -> Void in
                    var resultTxt:String!="failed"
                    var txt:String! = "支付失败"
                    if (result != nil) {
                        print("\(result)")
                        txt = result["memo"] as! String
                        var status = result["resultStatus"] as! NSObject
                        if ("\(status)" == "9000") {
                            
                            resultTxt = "success"
                        }
                    }
                    else{
                        txt =  "无法获取结果"
                    }
                    let jsonRes = JSON(["type":"res","param1":resultTxt,"param2":txt])
                    responseCallback(jsonRes.object)

                }

            }
        })
        //--------------------------------------------------------------------
        //调用一键分享
        bridge.registerHandler("sharesdk" ,handler: {
            data, responseCallback in
            //MapViewController
           self.ShowShareMenu()
        })
        //--------------------------------------------------------------------
        
        //--------------------------------------------------------------------
        //调用地图
        bridge.registerHandler("cmv" ,handler: {
            data, responseCallback in
            //MapViewController
            let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("mapview") as! MapViewController
            self.navigationController?.pushViewController(dvc, animated: true)
        })
        //--------------------------------------------------------------------
        //qq是否安装,待废弃
        bridge.registerHandler("isqqinstalled",handler: {
            data, responseCallback in
            var txt = "false"
            if TencentOAuth.iphoneQQInstalled() == true{
                txt = "true"
            }
            let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
            responseCallback(jsonRes.object)
            

        })
        //--------------------------------------------------------------------
        //qq wx是否安装
        bridge.registerHandler("isinstalled",handler: {
            data, responseCallback in
            let json = JSON(data)
            if let paramname = json["param1"].string{
                
            var txt = "false"
                
            if paramname == "qq"{
                if TencentOAuth.iphoneQQInstalled() == true{
                    txt = "true"
                }
            }
            else if paramname == "wx"{
                if WXApi.isWXAppInstalled() == true{
                    txt = "true"
                }
            }

            let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
            responseCallback(jsonRes.object)
            }
            
        })
        //--------------------------------------------------------------------
        //wx自动登录
        bridge.registerHandler("wxautologin",handler: {
            data, responseCallback in
            let json = JSON(data)
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.wxlogin(json, vc: self, block: {
                jsonRes in
                responseCallback(jsonRes.object)
            })
        })
        //--------------------------------------------------------------------
        //qq自动登录
        bridge.registerHandler("qqautologin",handler: {
            data, responseCallback in
            let json = JSON(data)
            if let paramappid = json["param1"].string{
                if let redirectURI = json["param2"].string{
//                    self._tencentOAuth = TencentOAuth(appId:"101220859",andDelegate:self);
//                    self._tencentOAuth?.redirectURI = "www.grw.com18.cn/wap/login.jsp"
                    self._tencentOAuth = TencentOAuth(appId:paramappid,andDelegate:self);
                    self._tencentOAuth?.redirectURI = redirectURI
                }
            }

            let permissions:NSArray = [
                kOPEN_PERMISSION_GET_USER_INFO,
                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                kOPEN_PERMISSION_ADD_ALBUM,
                kOPEN_PERMISSION_ADD_IDOL,
                kOPEN_PERMISSION_ADD_ONE_BLOG,
                kOPEN_PERMISSION_ADD_PIC_T,
                kOPEN_PERMISSION_ADD_SHARE,
                kOPEN_PERMISSION_ADD_TOPIC,
                kOPEN_PERMISSION_CHECK_PAGE_FANS,
                kOPEN_PERMISSION_DEL_IDOL,
                kOPEN_PERMISSION_DEL_T,
                kOPEN_PERMISSION_GET_FANSLIST,
                kOPEN_PERMISSION_GET_IDOLLIST,
                kOPEN_PERMISSION_GET_INFO,
                kOPEN_PERMISSION_GET_OTHER_INFO,
                kOPEN_PERMISSION_GET_REPOST_LIST,
                kOPEN_PERMISSION_LIST_ALBUM,
                kOPEN_PERMISSION_UPLOAD_PIC,
                kOPEN_PERMISSION_GET_VIP_INFO,
                kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO]
            self._tencentOAuth?.authorize(permissions as! [AnyObject],inSafari:false)
            
            func onLoginResult(jsonRes:JSON!)->Void{
                responseCallback(jsonRes.object)
            }
            self.qqautologinresult = onLoginResult
        })

        //--------------------------------------------------------------------

        
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
    
    func tencentDidLogin()
    {
        var txt = "{\"accessToken\":\"\(self._tencentOAuth!.accessToken)\",\"openId\":\"\(self._tencentOAuth!.openId)\",\"expirationDate\":\"\(self._tencentOAuth!.expirationDate.description)\"}"
//        
      //  var txt = "\(self._tencentOAuth?.accessToken),\(self._tencentOAuth?.openId)"
        let jsonRes = JSON(["type":"res","param1":"success","param2":txt])
        self.qqautologinresult?(jsonRes)
    }
    
    func tencentDidNotNetWork(){
        let jsonRes = JSON(["type":"res","param1":"failed","param2":"tencentDidNotNetWork"])
        
        self.qqautologinresult?(jsonRes)
    }
    
    func tencentDidLogout(){
        let jsonRes = JSON(["type":"res","param1":"failed","param2":"tencentDidLogout"])
        
        self.qqautologinresult?(jsonRes)
    }
    
    func tencentDidNotLogin(cancelled:Bool)
    {
        let jsonRes = JSON(["type":"res","param1":"failed","param2":"tencentDidNotLogin"])
        
        self.qqautologinresult?(jsonRes)
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
    
    /**
    * 显示分享菜单示例
    */
    func ShowShareMenu() {
        
        //1.创建分享参数
        var shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Auto)
        //2.进行分享
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: println("分享成功")
            case SSDKResponseState.Fail:    println("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("分享取消")
                
            default:
                break
            }
        }
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
