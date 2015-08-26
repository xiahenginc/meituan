//
//  AppDelegate.swift
//  美团
//
//  Created by wxqdev on 15/6/2.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

typealias onWxLoginResult = (JSON!) ->Void

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    
    typealias onChooseImage = (UIImage!) ->Void
    class inner:NSObject,UzysAssetsPickerControllerDelegate {
        var delegate:onChooseImage?
         func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!){
            
            if(assets.count != 0){
                var assets_array = assets as NSArray
                assets_array.enumerateObjectsUsingBlock({ obj, index, stop in
                    println(index)
                    var representation:ALAsset = obj as! ALAsset
                    var returnImg = UIImage(CGImage: representation.defaultRepresentation().fullResolutionImage().takeUnretainedValue(), scale:CGFloat(representation.defaultRepresentation().scale()), orientation:UIImageOrientation(rawValue: representation.defaultRepresentation().orientation().rawValue)!)
                    self.delegate?(returnImg!)
                })
            }
        }
        func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker:UzysAssetsPickerController){
            
        }
//        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
//        {
//            picker.dismissViewControllerAnimated(true, completion: nil)
//            var image = info[UIImagePickerControllerOriginalImage] as? UIImage
//            self.delegate?(image!)
//        }
//        func imagePickerControllerDidCancel(picker: UIImagePickerController)
//        {
//            println("picker cancel.")
//        }
    }
    var istance = inner()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        _setupShareSDK()
        _setupProxy()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func getSubString(s:String,starts:String,ends:String)->String{
        println("getSubString:\(s)")
        var rets = ""
        let names = s.componentsSeparatedByString(ends)
        if(names.count > 1){
            let uris = names[0].componentsSeparatedByString(starts)
            if(uris.count > 0 ){
                rets = uris[uris.count - 1]
            }
        }
        return rets
    }

    func _setupProxy(){
        WebViewProxy.handleRequestsWithHost("localdevice", handler: {
                        (req:NSURLRequest!,res:WVPResponse! )-> Void in
            //http://localdevice/qr#->扫描二维码
            var uriid = self.getSubString(req.URLString,starts: "/",ends: "#")
            println(uriid)
            dispatch_sync(dispatch_get_main_queue(), {
                if uriid == "pic"{
                    dispatch_async(dispatch_get_main_queue(), {

                        var curvc = self.getActivityViewController() //as? UINavigationController
                        var picker = UzysAssetsPickerController()
                        picker.maximumNumberOfSelectionVideo = 0;
                        picker.maximumNumberOfSelectionPhoto = 1;
                        func onChooseImage(image:UIImage!)->Void{
                            res.respondWithImage(image)
                        }
                        
                        self.istance.delegate = onChooseImage
                        picker.delegate = self.istance
                       // curvc?.pushViewController(picker!, animated: true)
                        curvc?.presentViewController(picker, animated: true, completion: nil)
                        
                    })
                }
            })
        })
    }
    
    func topViewController() -> UIViewController {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        return topViewController(app.window!.rootViewController!)
    }
    
    func topViewController(rootViewController: UIViewController) -> UIViewController {
        if let presented = rootViewController.presentedViewController {
            if presented is UINavigationController {
                let navi = presented as! UINavigationController
                let lastViewController = navi.viewControllers.last as! UIViewController
                return topViewController(lastViewController)
            }
            return topViewController(presented)
        } else {
            return rootViewController
        }
    }
        
      
    // 获取当前处于activity状态的view controller
    func getActivityViewController() ->UIViewController?{
        var result: UIViewController?
        var window = UIApplication.sharedApplication().keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.sharedApplication().windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin as? UIWindow
                    break
                }
            }
        }
        
        if let views = window?.subviews {
            if !views.isEmpty {
                let frontView: AnyObject? = window?.subviews[0]
                let nextResponder = frontView?.nextResponder()
                if nextResponder is UIViewController {
                    result = nextResponder as? UIViewController
                } else {
                    result = window?.rootViewController
                }
            }
        }
        return result
    }
    
    var wxloginResult:onWxLoginResult?
    var alipayResult:onWxLoginResult?
   
    func wxlogin(reqJson:JSON,vc:UIViewController,block:onWxLoginResult){
        self.wxloginResult = block
        var req = SendAuthReq()
        req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        req.state = reqJson["param1"].string
        req.openID = reqJson["param2"].string
        WXApi.sendAuthReq(req, viewController: vc, delegate: self)
    }

    func onReq(req: BaseReq!) {
        println("onReq called")
    }
    func onResp(resp: BaseResp!) {
        println("onResp called")
        
        if resp is SendAuthResp{
            let result = resp as! SendAuthResp
            var txtContent = ""
            var txtResult = "failed"
            if result.errCode == 0{
                txtResult = "success"
                txtContent =  "{\"state\":\"\(result.state)\",\"code\":\"\(result.code)\",\"lang\":\"\(result.lang)\",\"country\":\"\(result.country)\"}"
            }
            else{
                txtContent =  "{\"errCode\":\"\(result.errCode)\",\"errStr\":\"\(result.errStr)\"}"
            }

            let jsonRes = JSON(["type":"res","param1":txtResult,"param2":txtContent])
            self.wxloginResult?(jsonRes)
        }
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool{
        if url.scheme == "wx388f804d2a9cb9b4" {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        else if url.scheme == "tencent1104714921" {
            return TencentOAuth.HandleOpenURL(url)
        }
        return true
        
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.scheme == "wx388f804d2a9cb9b4" {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        else if url.scheme == "tencent1104714921" {
            return TencentOAuth.HandleOpenURL(url)
        }
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: {(result) -> Void in
                print(result as NSDictionary)
                
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
                self.alipayResult?(jsonRes)

            })
            return true
        }
        return true
    }
    
    func _setupShareSDK(){
        /**
        *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
        *  在将生成的AppKey传入到此方法中。
        *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
        *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
        *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
        */
        ShareSDK.registerApp("9117123bad18",
            activePlatforms : [
                SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,
                SSDKPlatformType.SubTypeQZone.rawValue,
                SSDKPlatformType.SubTypeQQFriend.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("4117424136",
                        appSecret : "37ae80802aff17306dc3267244e4f9e1",
                        redirectUri : "",
                        authType : SSDKAuthTypeBoth)
                    break
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx388f804d2a9cb9b4", appSecret: "b139299de10afe65ddf8947dd31e915c")
                    break
                    
                    
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId("1104714921",
                        appKey : "DT7VkRfm2n6Efe54",
                        authType : SSDKAuthTypeBoth)
                    break
                case SSDKPlatformType.SubTypeQQFriend:
                    appInfo.SSDKSetupQQByAppId("1104714921",
                        appKey : "DT7VkRfm2n6Efe54",
                        authType : SSDKAuthTypeBoth)
                    break
                case SSDKPlatformType.SubTypeQZone:
                    appInfo.SSDKSetupQQByAppId("1104714921",
                        appKey : "DT7VkRfm2n6Efe54",
                        authType : SSDKAuthTypeBoth)
//                    appInfo.connectQZoneWithAppKey("1104714921",
//                        appKey : "DT7VkRfm2n6Efe54",
//                        qqApiInterfaceCls : QQApiInterface.classForCoder(),
//                        tencentOAuthCls:TencentOAuth.classForCoder())
//                    break

                default:
                    break
                }
        })

    }
}

