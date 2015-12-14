//
//  AppDelegate.swift
//  z
//
//  Created by Ope on 7/20/15.
//  Copyright (c) 2015 oooseun. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    
    enum ShortcutType: String {
        case webcam = "webcam"
        case netflix = "netflix"
        case alloff = "alloff"
        case allon = "allon"
    
    }
    var vc = ViewController()
    var window: UIWindow?
    var defaults = NSUserDefaults()
    
    let locationManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION")
        
        
        // Otherwise present a local notification
        let notification = UILocalNotification()
        notification.alertBody = "Welcome home"
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
        if defaults.valueForKey("inIthaca") as? Bool == true {
        simpleGetRequestInIthaca(vc.homelink, wifiState: vc.checkIfReachableViaWifi())
        } else {
            vc.getRequest(vc.homelink)

        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("DID EXIT REGION")
        
        // Otherwise present a local notification
        let notification = UILocalNotification()
        notification.alertBody = "Bye!!"
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        vc.getRequest(vc.nothomelink)
        
        if defaults.valueForKey("inIthaca") as? Bool == true {
            simpleGetRequestInIthaca(vc.nothomelink, wifiState: vc.checkIfReachableViaWifi())
        } else {
            vc.getRequest(vc.nothomelink)
            
        }

    }


    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

       locationManager.delegate = self
       locationManager.requestAlwaysAuthorization()
        
        let settings = UIUserNotificationSettings(forTypes: [.Sound , .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
       
            let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(
                forTypes:
                [UIUserNotificationType.Alert,
                    UIUserNotificationType.Badge,
                    UIUserNotificationType.Sound],
                categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        
        var launchedFromShortcut=false
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem{
                launchedFromShortcut = true
                handleShortcutItem(shortcutItem)
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        return launchedFromShortcut
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
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
        
    }

    
     @available(iOS 9.0, *)
    func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -> Bool{
        var status:Bool = false
        if let shortcut = ShortcutType.init(rawValue: shortcutItem.type){
            switch(shortcut){
                case .webcam: UIApplication.sharedApplication().openURL(NSURL(string:"livecamspro://")!)
                status = true;
                break;
                case .netflix: vc.getRequest(vc.netflixandchilllink)
                status = true
                break;
                case .alloff: vc.getRequest(vc.allOffLink)
                status = true
                break;
                case .allon: vc.getRequest(vc.allOnLink)
                status = true
                break;
                
                
            }
        }
        return status
    }
    
    }

