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
    
    typealias onChooseImage = (UIImage!) ->Void
    class inner:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var delegate:onChooseImage?
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
        {
            picker.dismissViewControllerAnimated(true, completion: nil)
            var image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.delegate?(image!)
        }
        func imagePickerControllerDidCancel(picker: UIImagePickerController)
        {
            println("picker cancel.")
        }
    }
    var istance = inner()

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
                            var curvc = self.getActivityViewController() as? UINavigationController
                            var dvc = curvc?.storyboard?.instantiateViewControllerWithIdentifier("qr") as! QRCodeViewController
                                func onScanTxt(txt:String!)->Void{
                                    res.respondWithText(txt as String)
                                }
                            dvc.delegate =  onScanTxt
                            curvc?.pushViewController(dvc, animated: true)

                        })
                }
                if uriid == "pic"{
                    dispatch_async(dispatch_get_main_queue(), {

                        var curvc = self.getActivityViewController() as? UINavigationController
                        var picker:UIImagePickerController?=UIImagePickerController()
                        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                        func onChooseImage(image:UIImage!)->Void{
                            res.respondWithImage(image)
                        }
                        
                        self.istance.delegate = onChooseImage
                        picker?.delegate = self.istance
                       // curvc?.pushViewController(picker!, animated: true)
                        curvc?.visibleViewController?.presentViewController(picker!, animated: true, completion: nil)
                        
                    })
                }
                
                if uriid == "camera"{
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

}

