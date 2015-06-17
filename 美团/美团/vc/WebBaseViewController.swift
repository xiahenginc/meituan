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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bridge = WebViewJavascriptBridge(forWebView: myWebView, handler: {
            data, responseCallback in
            let cmd = data as? String
            if cmd == "qr"{
               //点击QR二维码
                var dvc = self.storyboard?.instantiateViewControllerWithIdentifier("qr") as! QRCodeViewController
                func onScanTxt(txt:String!)->Void{
                    responseCallback(txt)
                }
                dvc.delegate =  onScanTxt
                self.navigationController?.pushViewController(dvc, animated: true)
               
            }
            else if cmd == "ras"{
                dispatch_async(dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotificationName("onLoginRefresh", object: nil)
                })
                responseCallback("刷新session成功")
            }
        })
//        bridge.registerHandler("swiftcalljssample" ,handler: {
//            data, responseCallback in
//            print("\(data)")
//            responseCallback("")
//        })
        
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
        loadurl()
    }
    
    func onClickTest(sender: UIViewController) {
        bridge.callHandler("swiftcalljssample",data:"从原生态调用js")
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
