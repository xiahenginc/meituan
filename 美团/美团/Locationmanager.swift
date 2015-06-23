//
//  Locationmanager.swift
//  Movii
//
//  Created by Pedro Piñera Buendía on 13/12/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationUpdate = (issuccess:Bool,location: CLLocation?) -> ()

class LocationManager: NSObject, CLLocationManagerDelegate
{
    //MARK: - Attributes
    
    private var manager: CLLocationManager?
    private var listener: LocationUpdate?
    
    //MARK: - Singleton pattern
    
    private struct SharedInstance {
        static var instance: LocationManager?
    }
    
    class func getInstance() -> LocationManager
    {
        if (SharedInstance.instance == nil)  {
            SharedInstance.instance = LocationManager()
            SharedInstance.instance?.initManager()
        }
        return SharedInstance.instance!
    }
    
    func initManager(){
        self.manager = CLLocationManager()
        self.manager?.delegate = self
        self.manager?.desiredAccuracy=kCLLocationAccuracyBest
        self.manager?.distanceFilter=kCLDistanceFilterNone
        self.manager?.requestWhenInUseAuthorization()
    }
    
    
    //MARK: - Public methods
    
    func startMonitoringSignificantLocationChanges(listener: LocationUpdate)
    {

        self.manager?.startMonitoringSignificantLocationChanges()
        self.manager?.startUpdatingLocation()
        self.listener = listener
    }
    
    func stopMonitoringSignificantLocationChanges()
    {
        self.manager!.stopMonitoringSignificantLocationChanges()
        self.listener = nil
    }
    
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let l = listener {
            let location: CLLocation? = locations.last as? CLLocation
            if (location == nil) {
                l(issuccess: false,location: nil)
                return
            }
            l(issuccess: true,location: location!)
        }
    }
}