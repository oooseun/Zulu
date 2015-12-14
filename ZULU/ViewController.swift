//
//  ViewController.swift
//  z
//
//  Created by Ope on 7/20/15.
//  Copyright (c) 2015 oooseun. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import AVFoundation
import AVKit
import LocalAuthentication
import CoreLocation
import MapKit
import Charts






var swiftRequest = SwiftRequest()

class ViewController:   UIViewController,CLLocationManagerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    var reachability: Reachability?


    var shutdownlink:String = "http://192.168.0.100:7760/suspend"
    var locklink:String = "http://192.168.0.100:7760/lock"
    var webcamlink:String = "livecamspro://"
    var mjpeglink:String = "http://192.168.0.100:4567"
    var netflixandchilllink:String = "http://192.168.0.100:23456/netflix"
    var sleeplink:String = "http://192.168.1.100:23456/sleep"
    var homelink:String = "http://192.168.1.100:23456/home"
    var nothomelink:String = "http://192.168.1.100:23456/nothome"
    var weatherlink:String = "darksky://"
    var item=0;
    var ini:String = "wrong"
    var ishome:String = ""
    var motion:Bool = false
    var noise:Float = 0.0
    var lightLevel:Float = 0
    var noiseThreshold:Float = 150
    var webcamstatus:String = ""
    var pings:Int = 0
    var Latitude:Double = 0
    var Longitude:Double = 0
    var allOffLink:String = "http://192.168.1.100:23456/alloff"
    var allOnLink:String  = "http://192.168.1.100:23456/allon"
    var uptime:String = ""
    var switch1link:String = "http://192.168.1.100:23456/state1"
    var switch2link:String = "http://192.168.1.100:23456/state2"
    var switch3link:String = "http://192.168.1.100:23456/state3"
    var switch4link:String = "http://192.168.1.100:23456/state4"
    var vitalsLink:String  = "http://192.168.1.100:23456/vitals"

    var motionlightlink:String =  "http://192.168.1.100:23456/motionlight"
    var motionlight1:Int = 3;
    var motionlight2:Int = 3;
    var motionlight3:Int = 3;
    var motionlight4:Int = 3;

    var tempArray:[String]! = ["0",".25",".50",".75","1","1.25","1.5","1.75","2.0"];
    var tempData:[Double] = [0,0,0,0,0,0,0,0,0]
    var tempDataLong:[Double] = []
    var tempAsNSArray:NSArray = []


    var defaultColor = UIColor(colorLiteralRed: 227/256, green: 56/256, blue: 56/256, alpha: 0.93)
    var defaultGreenColor = UIColor(colorLiteralRed: 92/256, green: 216/256, blue: 50/256, alpha: 1.0)
    var nightModeColor = UIColor(colorLiteralRed: 4/256, green: 10/256, blue: 40/256, alpha: 0.91)
    var nightModeBackgroundColor = UIColor(colorLiteralRed: 64/256, green: 64/256, blue: 64/256, alpha: 1.0)
    var nightModeSleepColor = UIColor(colorLiteralRed: 7/256, green: 131/256, blue: 231/256, alpha: 1.0)
    var nightModeDarkerGreenColor = UIColor(colorLiteralRed: 79/256, green: 132/256, blue: 21/256, alpha: 1.0)


    @IBOutlet weak var lineChartView: LineChartView!
    //var isLineViewChartShowing:Bool = true

    @IBOutlet var lineChartViewTapped: UITapGestureRecognizer!

    @IBAction func lineChartViewTappedAction(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.lineChartView.alpha = 0.0
            }, completion: nil)
        //self.lineChartView.hidden = true
        delay(0.6){self.lineChartView.clear()}
        }

    @IBAction func tempLabelTapped(sender: AnyObject) {
        self.updateTempArray()
        self.setChart(self.tempArray, values: self.tempData)
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.lineChartView.alpha = 1.0
            self.lineChartView.hidden = false}, completion: nil)


    }




    @IBAction func aboutZulu(sender: AnyObject) {
        let alertController = UIAlertController(title: "Hi there!", message:
            "This is a Semi-customizable home automation app made by Ope Oladipo Copyright (c)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yeah ok", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil);

    }

    @IBAction func powerButton(sender: AnyObject) {
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication needed to shutdown Computer"

        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in

                if success {
                    self.getRequest(self.shutdownlink)
                    print("Authentication successful! :) ")
                } else {
                    switch policyError!.code
                    {
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system.")
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user.")
                    case LAError.PasscodeNotSet.rawValue:
                        print("Passcode Not Set")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            let nopasscodeAlert = UIAlertController(title: "No Bueno ", message: "Passcodes aren't supported at this time.", preferredStyle: .Alert)
                            nopasscodeAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                            self.presentViewController(nopasscodeAlert, animated: true, completion: nil)
                        })
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter password.")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            //self.showPasswordAlert()
                            let nopasscodeAlert = UIAlertController(title: "No Bueno ", message: "Passcodes aren't supported at this time.", preferredStyle: .Alert)
                            nopasscodeAlert.addAction(UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil))
                            self.presentViewController(nopasscodeAlert, animated: true, completion: nil)
                        })
                    default:
                        print("Authentication failed! :(")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            let nopasscodeAlert = UIAlertController(title: "No Bueno ", message:nil, preferredStyle: .Alert)
                            nopasscodeAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                            self.presentViewController(nopasscodeAlert, animated: true, completion: nil)
                        })
                    }
                }

            })
        }
        else
        {
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                //self.showPasswordAlert()
            })
        }


    }
    @IBAction func settingsButton(sender: AnyObject) {
    }

    /*******  Web View ******/

    @IBOutlet weak var webcamView: UIWebView!


    /***********************/


    @IBOutlet var mainBackgroundView: UIView!

    @IBOutlet weak var tempView: UIView!

    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var outsideTemp: UILabel!

    @IBOutlet weak var weatherIcon: UIImageView!

    @IBOutlet weak var lockButtonIcon: UIImageView!

    @IBOutlet weak var lockButtonColor: UIButton!

    @IBOutlet weak var lightProgress: UIProgressView!


    @IBAction func lockButton(sender: AnyObject) {

        lockHome()
    }


    @IBAction func webcam(sender: AnyObject) {

        UIApplication.sharedApplication().openURL(NSURL(string:webcamlink)!)

    }

    @IBAction func sleep(sender: AnyObject) {
            //getRequest(self.sleeplink)
            simpleGetRequestInIthaca(self.sleeplink, wifiState: checkIfReachableViaWifi())

    }
    @IBOutlet weak var soundButton: UIButton!

    @IBOutlet weak var brightnessButton: UIButton!

    @IBOutlet weak var motionButton: UIButton!
    @IBAction func netflixChill(sender: AnyObject) {
        getRequest(self.netflixandchilllink)

    }

    var state1 = "off" ;
    var state2 = "on" ;
    var state3 = "on" ;
    var state4 = "off" ;
    @IBAction func switch1(sender: AnyObject) {
//        let url = NSURL(string: "http://192.168.1.100:23456/state1")
//
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)  {( error) in
//
//        } ; task.resume();


        swiftRequest.get(switch1link,callback: {err,response,body in
            if (err == nil){
                print(body!)
            } else if (err != nil){
                print(err!);
            }
            })

        if state1 == "on" {
        iconswitch1.image  = UIImage(named: "off 2")
        state1="off"
        } else{
        iconswitch1.image  = UIImage(named: "on 2")
        state1="on"
        }

    }
    @IBAction func switch2(sender: AnyObject) {

        swiftRequest.get(switch2link,callback: {err,response,body in
            if (err == nil){
                print(body!)
            } else if (err != nil){
                print(err!);
            }
        })


        if state2 == "on" {

            iconswitch2.image  = UIImage(named: "off 2")
            state2="off"
        } else{
            iconswitch2.image  = UIImage(named: "on 2")
            state2="on"
        }
    }
    @IBAction func switch3(sender: AnyObject) {

        swiftRequest.get(switch3link,callback: {err,response,body in
            if (err == nil){
                print(body!)
            } else if (err != nil){
                print(err!);
            }
        })

        if state3 == "on" {

            iconswitch3.image  = UIImage(named: "off 2")
            state3="off"
        } else{
            iconswitch3.image  = UIImage(named: "on 2")
            state3="on"
        }
    }

    @IBAction func switch4(sender: AnyObject) {

        swiftRequest.get(switch4link,callback: {err,response,body in
            if (err == nil){
                print(body!)
            } else if (err != nil){
                print(err!);
            }
        })

        if state4 == "on" {

            iconswitch4.image  = UIImage(named: "off 2")
            state4="off"
        } else{
            iconswitch4.image  = UIImage(named: "on 2")
            state4="on"
        }
    }

    @IBAction func weatherDeepLinking(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: weatherlink)!)
    }

    @IBOutlet weak var iconswitch1: UIImageView!
    @IBOutlet weak var iconswitch2: UIImageView!
    @IBOutlet weak var iconswitch3: UIImageView!
    @IBOutlet weak var iconswitch4: UIImageView!

    //Set to be customizable in settings

    @IBOutlet weak var switch1label: UILabel!

    @IBOutlet weak var switch2label: UILabel!

    @IBOutlet weak var switch3label: UILabel!

    @IBOutlet weak var switch4label: UILabel!

    @IBOutlet weak var Indicator: UIButton!

    @IBOutlet weak var netflixChillButtonView: UIButton!
    @IBOutlet weak var webcamButtonView: UIButton!
    @IBOutlet weak var switch1View: UIButton!
    @IBOutlet weak var switch2View: UIButton!
    @IBOutlet weak var switch3View: UIButton!
    @IBOutlet weak var switch4View: UIButton!
    @IBOutlet weak var sleepButtonView: UIButton!


    internal func isNilOrEmpty(string: NSString?) -> Bool {
        switch string {
            case .Some(let nonNilString): return nonNilString.length == 0
        default:            return true
        }
    }

    var vitalTemp = ""
    var vitalOutsideTemp = ""
    var icon = ""
    //func updateVitals() -> Bool{
    func updateVitals(){

        let url = NSURL(string:self.vitalsLink)// self.vitalsLink)

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)  {(data, response, error) in

            if data == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.Indicator.hidden = false
                })


            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.Indicator.hidden = true
                })


                do {
                let vitals = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                //print(vitals["temp"]!)

                self.vitalTemp = String(vitals["temp"]!)
                self.vitalOutsideTemp = String(vitals["outsideTemp"]!)
                self.icon = String(vitals["icon"]!)
                self.ishome = (vitals["ishome"]) as! String
                self.motion = (vitals["ismotion"]) as! Bool
                self.noise = (vitals["isnoise"]) as! Float
                self.lightLevel = (vitals["light"]) as! Float
                self.state1 = (vitals["state1"]) as! String
                self.state2 = (vitals["state2"]) as! String
                self.state3 = (vitals["state3"]) as! String
                self.state4 = (vitals["state4"]) as! String
                self.webcamstatus = (vitals["webcamstatus"]) as! String
                self.pings = (vitals["visits"]) as! Int
                self.uptime = (vitals["uptime"]) as! String
                self.motionlight1 = (vitals["motionlight1"]) as! Int
                self.motionlight2 = (vitals["motionlight2"]) as! Int
                self.motionlight3 = (vitals["motionlight3"]) as! Int
                self.motionlight4 = (vitals["motionlight4"]) as! Int
                //self.tempDataLong = temp
                    //print(vitals["tempArray"][0])
                        if let temp = vitals["tempArray"] {
                            self.tempAsNSArray = temp as! NSArray
                            //print(self.tempAsNSArray[0])
                    }


                //print(self.vitalTemp + " is the temp in F")
                //print(self.icon)


                self.defaults.setValue(self.webcamstatus, forKeyPath: "webcamstatus")
                self.defaults.setFloat(self.lightLevel, forKey: "light")
                self.defaults.setFloat(self.noise, forKey: "noise")
                self.defaults.setValue(self.pings, forKey: "pings")
                self.defaults.setValue(self.uptime, forKeyPath: "uptime")
                self.defaults.setValue(self.motionlight1, forKey: "motionlight1")
                self.defaults.setValue(self.motionlight2, forKey: "motionlight2")
                self.defaults.setValue(self.motionlight3, forKey: "motionlight3")
                self.defaults.setValue(self.motionlight4, forKey: "motionlight4")




                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    //Updates motion indictator
                    if (self.motion == true) && (self.ishome == "no"){
                        self.motionButton.backgroundColor = UIColor.redColor()
                        self.motionNotification()
                    } else if self.motion == true{
                        self.motionButton.backgroundColor = UIColor.redColor()

                    } else {
                        self.lockButtonColor.backgroundColor = self.getNightMode() ? self.nightModeDarkerGreenColor : UIColor.greenColor()
                    }

                    //Updates noise indicator
                    if (self.noise > self.noiseThreshold){ self.soundButton.backgroundColor = UIColor.redColor()
                    }else{
                        self.soundButton.backgroundColor = UIColor.whiteColor()
                    }

                    //Updates light progress view
                    self.lightProgress.progress = (self.lightLevel)/100

                    //Updates weather icon
                    switch self.icon {
                    case  "clear-day" :
                        self.weatherIcon.image = UIImage(named: "Sunny")
                    case  "rain" :
                        self.weatherIcon.image = UIImage(named: "Rainy")
                    case  "wind" :
                        self.weatherIcon.image = UIImage(named: "Windy")
                    case  "cloudy" :
                        self.weatherIcon.image = UIImage(named: "Cloudy")
                    case  "fog" :
                        self.weatherIcon.image = UIImage(named: "Foggy")
                    case  "snow" :
                        self.weatherIcon.image = UIImage(named: "Snowflake")
                    case  "clear-night" :
                        self.weatherIcon.image = UIImage(named: "Moon")
                    case  "partly-cloudy-night" :
                        self.weatherIcon.image = UIImage(named: "CloudyNight")
                    default :
                        self.weatherIcon.image = UIImage(named: "Cloudy")
                    }

                    //Updates weather itself
                    self.tempLabel.text  = self.vitalTemp + "˚"
                    self.outsideTemp.text  = self.vitalOutsideTemp + "˚"

                    if (self.ishome == "no"){
                        self.lockButtonIcon.image = UIImage(named:"Padlock_with_keyhole_512")
                        self.lockButtonColor.backgroundColor = UIColor.redColor()
                    } else if (self.ishome == "yes"){
                        self.lockButtonIcon.image = UIImage(named:"Padlock_open_with_keyhole_512")
                        self.lockButtonColor.backgroundColor = self.getNightMode() ? self.nightModeDarkerGreenColor : UIColor.greenColor()
                    }
                    /*************************************************************************************/
                    if self.state1 == "off" {

                        self.iconswitch1.image  = UIImage(named: "off 2")
                        self.state1="off"
                    } else{
                        self.iconswitch1.image  = UIImage(named: "on 2")
                        self.state1="on"
                    }



                    if self.state2 == "off" {

                        self.iconswitch2.image  = UIImage(named: "off 2")
                        self.state2="off"
                    } else{
                        self.iconswitch2.image  = UIImage(named: "on 2")
                        self.state2="on"
                    }


                    if self.state3 == "off" {

                        self.iconswitch3.image  = UIImage(named: "off 2")
                        self.state3="off"
                    } else{
                        self.iconswitch3.image  = UIImage(named: "on 2")
                        self.state3="on"
                    }



                    if self.state4 == "off" {

                        self.iconswitch4.image  = UIImage(named: "off 2")
                        self.state4="off"
                    } else{
                        self.iconswitch4.image  = UIImage(named: "on 2")
                        self.state4="on"
                    }
                      /*************************************************************************************/

                })


                } catch {
                    print(error)
                }
                }

            }  ;task.resume();
          }


    func hideIndicator(x:Bool){
        if (x){
            self.Indicator.hidden = true
        } else if (!x) {
            self.Indicator.hidden = false
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func motionNotification(){
        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Open Zulu"
        localNotification.alertBody =  "Hey Fam, there's been motion in your room"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)


    }

     func getRequest(url:String){
        swiftRequest.get(url,callback: {err,response,body in
            if (err == nil){
                print(body!)
            } else if (err != nil){
                print(err!);
                let alertController = UIAlertController(title: "Check Internet connectivity", message:
                    "There seems to be a problem with your connection, Requests are timing out.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                alertController.addAction(UIAlertAction(title: "Open Settings", style: UIAlertActionStyle.Cancel){ action -> Void in
                    if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(appSettings)
                    }
                    }
                )

                self.presentViewController(alertController, animated: true, completion: nil);}
        })

    }

    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID ", message: "Please enter your PIN.", preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in

            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "password"
                {
                    print("Authentication successful! :) ")
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        alertController.addAction(defaultAction)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in

            textField.placeholder = "Password"
            textField.secureTextEntry = true

        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func authenticateUser()
    {
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication needed to use ZULU"

        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in

                if success
                {
                    self.getRequest(self.shutdownlink)
                    print("Authentication successful! :) ")
                }
                else
                {
                    switch policyError!.code
                    {
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system.")
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user.")

                    case LAError.UserFallback.rawValue:
                        print("User selected to enter password.")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Authentication failed! :(")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }

            })
        }
        else
        {
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.showPasswordAlert()
            })
        }
    }

    func lockHome(){
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if (ishome == "yes"){
            swiftRequest.get(self.nothomelink,callback: {err,response,body in
                if (err == nil){
                    print(body!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.lockButtonIcon.image = UIImage(named:"Padlock_with_keyhole_512")
                        self.lockButtonColor.backgroundColor = UIColor.redColor()
                    })
                } else if (err != nil){
                    print(err!);
                    let alertController = UIAlertController(title: "Check Internet connectivity", message:
                        "There seems to be a problem with your connection, Requests are timing out.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    alertController.addAction(UIAlertAction(title: "Open Settings", style: UIAlertActionStyle.Cancel){ action -> Void in
                        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.sharedApplication().openURL(appSettings)
                        }
                        }
                    )

                    self.presentViewController(alertController, animated: true, completion: nil);}
            })
        } else {
            swiftRequest.get(self.homelink,callback: {err,response,body in
                if (err == nil){
                    print(body!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.lockButtonIcon.image = UIImage(named:"Padlock_open_with_keyhole_512")
                        self.lockButtonColor.backgroundColor = self.getNightMode() ? self.nightModeDarkerGreenColor : UIColor.greenColor()
                    })

                } else if (err != nil){
                    print(err!);
                    let alertController = UIAlertController(title: "Check Internet connectivity", message:
                        "There seems to be a problem with your connection, Requests are timing out.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    alertController.addAction(UIAlertAction(title: "Open Settings", style: UIAlertActionStyle.Cancel){ action -> Void in
                        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.sharedApplication().openURL(appSettings)
                        }
                        }
                    )

                    self.presentViewController(alertController, animated: true, completion: nil);}
            })

        }
    }

    func checkIfReachableViaWifi() -> Bool{
        var isR:Bool = false
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("Unable to create\nReachability with address:\n\(address)")
                isR=false
        } catch {return false}
        if let reachability = reachability {
            if reachability.isReachableViaWiFi() {
                print("Reachable")
                isR = true
            } else {
                print("NotReachable via wifi")
                isR = false
            }
        }

        return isR


    }


    func setChart(dataPoints:[String],values:[Double]){
        lineChartView.noDataText = "Give me a few moments to gather your temp data"
        lineChartView.descriptionText = "Room temps"
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.autoScaleMinMaxEnabled = true
        lineChartView.pinchZoomEnabled = true
        lineChartView.drawBordersEnabled = false
        lineChartView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        lineChartView.animate(xAxisDuration: 0.9,yAxisDuration: 0.9)

        let yrightaxis = lineChartView.getAxis(lineChartView.rightAxis.axisDependency)
        yrightaxis.enabled = false
        let yleftaxis = lineChartView.getAxis(lineChartView.leftAxis.axisDependency)

        yleftaxis.startAtZeroEnabled = false
        yleftaxis.spaceTop = 0.2
        yleftaxis.spaceBottom = 0.2

        yleftaxis.gridColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)
        lineChartView.xAxis.gridColor =  UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)



        let l = lineChartView.legend
        l.enabled = false

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<tempData.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = LineChartData(xVals: tempArray, dataSet: chartDataSet)
        lineChartView.data = chartData
        chartDataSet.colors = [UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 0.9)]

    }

    func updateTempArray(){
        print(tempData)
        /*      IF you prefer to have the phone do it by itself, be wary though, this wasn't written with background execution in mind.
        if let x = self.defaults.arrayForKey("tempdata") as? [Double]{

        let tempTemparature = NSNumberFormatter().numberFromString(self.vitalTemp)
        tempData = x.reverse()
        tempData.append(tempTemparature as! Double)
        tempData = tempData.reverse()
        tempData.removeLast()
        } else {
            let tempTemparature = NSNumberFormatter().numberFromString(self.vitalTemp)
            tempData = tempData.reverse()
            tempData.append(tempTemparature as! Double)
            tempData = tempData.reverse()
            tempData.removeLast()

        }*/
       /* if let _ = tempDataLong as? [Double] {
            print(tempDataLong)
             tempData = Array(tempDataLong[1...9])
        }
        */


        for i in 1...9 {
            //print(tempAsNSArray[0])
            //print(Double(tempAsNSArray[i] as! NSString as String )!)
            tempData[i-1] = Double(tempAsNSArray[i-1] as! NSString as String )!
        }

        defaults.setObject(tempData, forKey: "tempdata")
        //print(self.tempData)


    }

    func getNightMode() -> Bool {
        return defaults.boolForKey("nightmode")

    }
    func nightModeAtNight() -> Bool{
        return defaults.boolForKey("nightmodeatnight")
    }
    internal func setNightMode(mode:Bool) {
        defaults.setBool(mode, forKey: "nightmode")
    }
    internal func setNightModeAtNight(mode:Bool) {
        defaults.setBool(mode, forKey: "nightmodeatnight")
    }

    func nightMode(){

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tempView.backgroundColor = self.nightModeColor
                self.switch1View.backgroundColor = self.nightModeColor
                self.switch2View.backgroundColor = self.nightModeColor
                self.switch3View.backgroundColor = self.nightModeColor
                self.switch4View.backgroundColor = self.nightModeColor
                self.sleepButtonView.backgroundColor = self.nightModeColor
                self.webcamButtonView.backgroundColor = self.nightModeColor
                self.mainBackgroundView.backgroundColor = self.nightModeBackgroundColor
                self.motionButton.backgroundColor = self.nightModeDarkerGreenColor
                self.lockButtonColor.backgroundColor = self.nightModeDarkerGreenColor
                self.netflixChillButtonView.setImage(UIImage(named: "Netflix_Chill_Dark"), forState: .Normal)
                })
        self.defaults.setBool(true, forKey: "nightmode")
        }


    func normalMode(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            self.tempView.backgroundColor = self.defaultColor
            self.switch1View.backgroundColor = self.defaultColor
            self.switch2View.backgroundColor = self.defaultColor
            self.switch3View.backgroundColor = self.defaultColor
            self.switch4View.backgroundColor = self.defaultColor
            self.sleepButtonView.backgroundColor = self.nightModeSleepColor
            self.webcamButtonView.backgroundColor = self.defaultColor
            self.motionButton.backgroundColor = UIColor.greenColor()
            self.lockButtonColor.backgroundColor = UIColor.greenColor()
            self.mainBackgroundView.backgroundColor = UIColor.whiteColor()
            self.netflixChillButtonView.setImage(UIImage(named: "Netflix_Chill"), forState: .Normal)
        })
        self.defaults.setBool(false, forKey: "nightmode")

        }



    /*

    @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {

            //hide Graph
            UIView.transitionFromView(graphView,
                toView: counterView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion:nil)
        } else {

            //show Graph
            UIView.transitionFromView(counterView,
                toView: graphView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }*/
        override func viewDidLoad() {
        super.viewDidLoad()
        //setChart(self.tempArray, values: self.tempData)


if vitalsLink != "http://192.168.1.100:23456/vitals" {
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateVitals"), userInfo: nil, repeats: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(60.0*15.0, target: self, selector: Selector("updateTempArray"), userInfo: nil, repeats: true)
}
        if let _ = defaults.objectForKey("latitude") {
            print("The Current Saved Home Latitude is ",defaults.doubleForKey("latitude"))
            print("The Current Saved Home Longitude is ",defaults.doubleForKey("longitude"))

        } else {print("No saved Home location yet")}


            print(checkIfReachableViaWifi())


            lineChartView.hidden = true

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateVitals()
        self.navigationController?.navigationBar.hidden = true
        print(locationManager.monitoredRegions)
        if let temp = self.defaults.stringForKey("switch1") {
            self.switch1link = temp
            print(temp)
        }
        if let temp = self.defaults.stringForKey("switch1") {self.switch1link = temp} //To save space and "readability i guess"
        if let temp = self.defaults.stringForKey("switch2") {self.switch2link = temp}
        if let temp = self.defaults.stringForKey("switch3") {self.switch3link = temp}
        if let temp = self.defaults.stringForKey("switch4") {self.switch4link = temp}
        if let temp = self.defaults.stringForKey("sleeplink") {self.sleeplink = temp}
        if let temp = self.defaults.stringForKey("netflixandchilllink") {self.netflixandchilllink = temp}
        if let temp = self.defaults.stringForKey("locklink") {self.locklink = temp}
        if let temp = self.defaults.stringForKey("webcamlink") {self.webcamlink = temp}
        if let temp = self.defaults.stringForKey("shutdownlink") {self.shutdownlink = temp}
        if let temp = self.defaults.stringForKey("vitalslink") {self.vitalsLink = temp}
        if let temp = self.defaults.stringForKey("homelink") {self.homelink = temp}
        if let temp = self.defaults.stringForKey("nothomelink") {self.nothomelink = temp}
        if let temp = self.defaults.stringForKey("weatherlink") {self.weatherlink = temp}

        if getNightMode()  {
            nightMode()
        } else
        {
            normalMode()
        }
        if nightModeAtNight() {

        }

    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBarHidden = false

    }

}
