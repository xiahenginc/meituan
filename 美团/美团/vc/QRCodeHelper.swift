//
//  QRCodeHelper
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



typealias onScanedText = (String!) ->Void

class QRCodeHelper: QRCodeReaderViewControllerDelegate {
    var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode])
    var delegate:onScanedText?
    var vc:UIViewController?
    func showView(vc:UIViewController!) {
        self.vc = vc
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: String?) in
                println("Completion with result: \(result)")
            }
            
            self.vc!.navigationController?.pushViewController(reader, animated: true)
            //self.vc!.presentViewController(reader, animated: true, completion: nil)
            
        }
    }
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        // self.vc!.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
        self.vc!.navigationController?.popViewControllerAnimated(true)
        self.delegate?(result)
        //})
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.vc!.navigationController?.popViewControllerAnimated(true)
        //self.vc!.dismissViewControllerAnimated(true, completion: nil)
    }
}
