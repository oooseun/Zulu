//
//  MapViewController.swift
//  ZULU
//
//  Created by Ope on 10/16/15.
//  Copyright © 2015 oooseun. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    var Latitude:Double = 0
    var Longitude:Double = 0
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager();
    var vc = ViewController()
    var homeAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func zoomButton(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager.distanceFilter = 100
        
        //print(locationManager.monitoredRegions)
        if !locationManager.monitoredRegions.isEmpty {
            let archivedLocation = defaults.objectForKey("location") as! NSData
            let tempLocation = NSKeyedUnarchiver.unarchiveObjectWithData( archivedLocation ) as! CLLocation
            addRadiusCircle(tempLocation,radius: defaults.doubleForKey("radius"))
            homeAnnotation.coordinate =  tempLocation.coordinate
            homeAnnotation.title = "Home!! 😃"
            mapView.addAnnotation(homeAnnotation)
        
        }
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

    @IBAction func addButton(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
            print("Requesting Location ...")
            

        } else {
            showSimpleAlertWithTitle("Please update to iOS 9.0+ 😃", message: "", viewController: self)
        }
        
        
        
    }
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
            print("Called didUpdateLocations")
            //print(locationManager.location!.coordinate)
            let Coordinates = CLLocationCoordinate2DMake(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
            let region = CLCircularRegion(center: Coordinates, radius: defaults.doubleForKey("radius"), identifier: "home")
            locationManager.startMonitoringForRegion(region)
        
            let archivedRegion = NSKeyedArchiver.archivedDataWithRootObject(region as CLRegion)
            defaults.setValue(archivedRegion, forKeyPath: "region")
            

            print(locationManager.monitoredRegions)
            addRadiusCircle(location.first!,radius: defaults.doubleForKey("radius"))
            let archivedLocation = NSKeyedArchiver.archivedDataWithRootObject(location.first! as CLLocation)
            defaults.setValue(archivedLocation, forKeyPath: "location")
            homeAnnotation.coordinate =  location.first!.coordinate
            homeAnnotation.title = "Home!! 😃"
            mapView.addAnnotation(homeAnnotation)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to Obtain User Location : \(error.localizedDescription)")
        showSimpleAlertWithTitle("Failed to get your location", message: "Please try again", viewController: self)

    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        showSimpleUIalert("Started Monitoring!")
        //showSimpleAlertWithTitle("Geofence Erected 😃", message: "", viewController: self)
        print("Called didstartMonitoring")


    }
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Something wrong with Regions")
    }
    
    
  
    func addRadiusCircle(location: CLLocation,radius:Double){
        self.mapView.delegate = self
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: radius as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    
    
    
  /*  func removeRadiusOverlay(mapView:MKMapView,location:CLLocation,radius:Double) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        if let overlays = mapView.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    if coord.latitude == location.coordinate.latitude && coord.longitude == location.coordinate.longitude && circleOverlay.radius == radius {
                        mapView!.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
        }
    }
*/
    /*
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION")
        
        vc.getRequest(vc.homelink)
        
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = "Welcome home"
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("DID EXIT REGION")
        
        vc.getRequest(vc.nothomelink)
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = "Bye!!"
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
    }
    
    */
    /*
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            showSimpleAlertWithTitle("Entered!", message: "", viewController: self)
        }
        print("DID ENTER REGION")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            showSimpleAlertWithTitle("Exited!!", message: "", viewController: self)
        }
        print("DID EXIT REGION")

    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func getLocation(){
        do{
            print("Getting location...............")
            try SwiftLocation.shared.currentLocation(Accuracy.Block, timeout: 30, onSuccess: { (location) -> Void in
                
                print(location)
                print("Latitude: ", String(location!.coordinate.latitude))
                print("Longitude: ", String(location!.coordinate.longitude))
                self.Latitude = location!.coordinate.latitude
                self.Longitude = location!.coordinate.longitude
                self.defaults.setDouble(location!.coordinate.latitude, forKey: "latitude")
                self.defaults.setDouble(location!.coordinate.longitude, forKey: "longitude")
                
                self.setGeofence();
                
                },onFail: { _ in print("Timeout!!!!!!!!!!!!!!!!!!!!!!!!!!!") })
        } catch ( let error) {
            print(error)
        }
    }
    
    
    func setGeofence() {
        if let _ = defaults.objectForKey("latitude") {
            
            do {
                let regionCoordinates = CLLocationCoordinate2DMake(defaults.doubleForKey("latitude"),defaults.doubleForKey("longitude"))
                let region = CLCircularRegion(center: regionCoordinates, radius: CLLocationDistance(30), identifier: "identifier_region");
                _ = try SwiftLocation.shared.monitorRegion(region,
                    onEnter: { (region) -> Void in
                        
                        self.vc.getRequest(self.vc.homelink)
                        print("Welcome Back Home Boss")
                        let localNotification: UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "You've entered the area"
                        localNotification.alertBody =  ""
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        localNotification.category = "invite"
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        
                        
                    }, onExit: {(region) -> Void in
                        
                        self.vc.getRequest(self.vc.nothomelink)
                        print("Exiting...")
                        let localNotification: UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "You've left the area"
                        localNotification.alertBody =  ""
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        localNotification.category = "invite"
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        
                        
                        
                })
            } catch(let error){print(error)}
            print("Geofence set to 30 radius")
        }
        
        
        
    }*/
    


}
