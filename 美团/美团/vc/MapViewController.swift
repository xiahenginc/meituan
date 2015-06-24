//
//  MapViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/23.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
           }
    deinit {
        println("MapViewController deinit...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        startLocation()

    }
    override func viewDidDisappear(animated: Bool){
         LocationManager.getInstance().stopMonitoringSignificantLocationChanges()
    }
    
    func startLocation(){
        
        LocationManager.getInstance().startMonitoringSignificantLocationChanges {
            (issuccess,location) -> () in
            
            println("startMonitoringSignificantLocationChanges callback...")
            var resultTxt:String!="failed"
            if issuccess {
                
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
                    println("reverseGeocodeLocation callback...")
                    if error != nil{
                        println(error)
                        return
                    }
                    
                    if placemarks != nil && placemarks.count > 0 {
                        let placemark = placemarks[0] as! CLPlacemark
                        let annotation = MKPointAnnotation()
                        annotation.title = "这里是我的位置"
                        annotation.subtitle = "测试用"
                        annotation.coordinate = placemark.location.coordinate
                        
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)
                    }
                    
                })
                
                
            }
           

        }
        

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "我的位置"
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 47, 47))
        leftIconView.image = UIImage(named: "menu1_1")
        annotationView.leftCalloutAccessoryView = leftIconView
        return annotationView
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
