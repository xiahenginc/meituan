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
        })
//        bridge.registerHandler("qr" ,handler: {
//            data, responseCallback in
//            println("click qr,Message from Javascript: \(data)")
//            responseCallback("thisisqrid")
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loadurl(url:String){
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
