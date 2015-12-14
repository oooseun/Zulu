//
//  File.swift
//  ZULU
//
//  Created by Ope on 10/17/15.
//  Copyright © 2015 oooseun. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

func showSimpleUIalert(title: String!) {
    let localNotification: UILocalNotification = UILocalNotification()
    localNotification.alertAction = "Open Zulu"
    localNotification.alertBody =  title
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.category = "invite"
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    
}
func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}
func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
}



func simpleGetRequestInIthaca(url:String,wifiState:Bool){
    let vc = ViewController()
    if wifiState {
        print("isReachableViaWIFI")
        print("1")
        print(wifiState)
    swiftRequest.get(url,callback: {err,response,body in
        if (err == nil){
            print(body!)
        } else if (err != nil){
            print(err!);
        }
        print("2")
    })
    } else if !wifiState {
        print("Not working")
        print(wifiState)

        delay(10){
            print("Called Again")
            simpleGetRequestInIthaca(url,wifiState: vc.checkIfReachableViaWifi())
        }
        print("3")
    }

}




func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

