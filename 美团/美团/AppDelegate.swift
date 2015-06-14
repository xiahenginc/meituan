//
//  AppDelegate.swift
//  美团
//
//  Created by wxqdev on 15/6/2.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
                if uriid == "qr"{
                    dispatch_async(dispatch_get_main_queue(), {
                            var curvc = self.getActivityViewController()
                        var dvc = curvc.storyboard?.instantiateViewControllerWithIdentifier("qr") as! QRCodeViewController
                                func onScanTxt(txt:String!)->Void{
                                    res.respondWithText(txt as String)
                                }
                                dvc.delegate =  onScanTxt

                        })
                }
            })
        })
    }
        
      
    // 获取当前处于activity状态的view controller
    func getActivityViewController() ->UIViewController{
        var activityViewController:UIViewController?
        var win = UIApplication.sharedApplication().keyWindow
        if(win?.windowLevel != UIWindowLevelNormal){
            var windows = UIApplication.sharedApplication().windows
            for tmpWin in windows{
                if tmpWin.windowLevel == UIWindowLevelNormal{
                    win = tmpWin as? UIWindow
                    break
                }
            }
        }
        
        var viewsArray = win?.subviews
        if viewsArray?.count > 0{
            var frontView = viewsArray?[0] as! UIView
            if (frontView.nextResponder()?.isKindOfClass(UIViewController) != nil) {
                activityViewController = frontView.nextResponder() as? UIViewController
            }
            else{
                activityViewController =  win?.rootViewController;
            }
        }
        return activityViewController!
    }

}

