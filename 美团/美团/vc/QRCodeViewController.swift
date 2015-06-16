//
//  QRCodeViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



typealias onScanedText = (String!) ->Void

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var delegate:onScanedText?
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer:AVCaptureVideoPreviewLayer?
    var line = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = CGRectMake(50, 100, view.frame.width - 100, view.frame.height-130)
        
        var imgView = UIImageView(frame: frame)
        imgView.image = UIImage(named: "empty")
        imgView.alpha = 0.7
        view.addSubview(imgView)
        self.setupCamera()
        self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        session.startRunning()
        line.frame = CGRectMake(50, 130, view.frame.width - 100, 3)
//        line.backgroundColor = UIColor.greenColor()
        line.image = UIImage(named:"line.png")
        self.view.addSubview(line)
        UIView.beginAnimations("id", context: nil)
        UIView.setAnimationDuration(3)
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        UIView.setAnimationRepeatCount(1000)
        line.frame = CGRectMake(50, 340, view.frame.width - 100,3)
        UIView.commitAnimations()
    
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        session.stopRunning()
        line.frame = CGRectMake(50, 130, view.frame.width - 100, 3)
        line.layer.removeAllAnimations()
    }
    func setupCamera() {
        
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error: NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        
        if(error != nil){
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = view.frame
        view.layer.insertSublayer(layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        //区域的原点在左上方（后面才知道坑苦我了！），然后区域是相对于设备的大小的，默认值是CGRectMake(0, 0, 1, 1)，这时候我才知道是有比例关系的，最大值才是1
        output.rectOfInterest = CGRectMake(CGFloat(50) / view.frame.width, CGFloat(130) / view.frame.height, (view.frame.width - 100) / view.frame.width, CGFloat(340) / view.frame.height)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        session.startRunning()

    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
        }
        else{
            return
        }
    
        self.session.stopRunning()
        println("code is \(stringValue)")
        self.delegate?(stringValue!)
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
