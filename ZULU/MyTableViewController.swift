//
//  MyTableViewController.swift
//  ZULU
//
//  Created by Ope on 10/10/15.
//  Copyright © 2015 oooseun. All rights reserved.
//

import UIKit
import MapKit


class MyTableViewController: UITableViewController,UITextFieldDelegate{
    var vc = ViewController()
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if (vc.webcamstatus == "play" ){webcamStatusIcon.image = UIImage(named: "play")}
        self.navigationController?.navigationBarHidden = false
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
         _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateStats"), userInfo: nil, repeats: true)
        if let radius = defaults.valueForKey("radius") {
            self.geoRadius.text = String(radius)
        } else {
            self.geoRadius.text = String(25)
            defaults.setValue(25, forKeyPath: "radius")
        }
       
        if defaults.valueForKey("inIthaca") == nil {
            defaults.setBool(true, forKey: "inIthaca")
        }
        if let temp = self.defaults.stringForKey("switch1") {self.textFieldLink1.text = temp} else {self.textFieldLink1.text = vc.switch1link}
        if let temp = self.defaults.stringForKey("switch2") {self.textFieldLink2.text = temp} else {self.textFieldLink2.text = vc.switch2link}
        if let temp = self.defaults.stringForKey("switch3") {self.textFieldLink3.text = temp} else {self.textFieldLink3.text = vc.switch3link}
        if let temp = self.defaults.stringForKey("switch4") {self.textFieldLink4.text = temp} else {self.textFieldLink4.text = vc.switch4link}
        if let temp = self.defaults.stringForKey("sleeplink") {self.textFieldLink5.text = temp} else {self.textFieldLink5.text = vc.sleeplink}
        if let temp = self.defaults.stringForKey("netflixandchilllink") {self.textFieldLink6.text = temp} else {self.textFieldLink6.text = vc.netflixandchilllink}
        if let temp = self.defaults.stringForKey("locklink") {self.textFieldLink7.text = temp} else {self.textFieldLink7.text = vc.locklink}
        if let temp = self.defaults.stringForKey("webcamlink") {self.textFieldLink8.text = temp} else {self.textFieldLink8.text = vc.webcamlink}
        if let temp = self.defaults.stringForKey("shutdownlink") {self.textFieldLink9.text = temp} else {self.textFieldLink9.text = vc.shutdownlink}
        if let temp = self.defaults.stringForKey("vitalslink") {self.textFieldLink10.text = temp} else {self.textFieldLink10.text = vc.vitalsLink}
        if let temp = self.defaults.stringForKey("homelink") {self.textFieldLink11.text = temp} else {self.textFieldLink11.text = vc.homelink}
        if let temp = self.defaults.stringForKey("nothomelink") {self.textFieldLink12.text = temp} else {self.textFieldLink12.text = vc.nothomelink}
        if let temp = self.defaults.stringForKey("weatherlink") {self.textFieldLink13.text = temp} else {self.textFieldLink13.text = vc.weatherlink}
        

        print(vc.checkIfReachableViaWifi())

    }
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        updateStats()
        if (self.defaults.integerForKey("motionlight1") == 1)  {self.motionLightSwitch1UI.setOn(true, animated: true) } else {self.motionLightSwitch1UI.setOn(false, animated: false)}
        if (self.defaults.integerForKey("motionlight2") == 1)  {self.motionLightSwitch2UI.setOn(true, animated: true) } else {self.motionLightSwitch2UI.setOn(false, animated: false)}
        if (self.defaults.integerForKey("motionlight3") == 1)  {self.motionLightSwitch3UI.setOn(true, animated: true) } else {self.motionLightSwitch3UI.setOn(false, animated: false)}
        if (self.defaults.integerForKey("motionlight4") == 1)  {self.motionLightSwitch4UI.setOn(true, animated: true) } else {self.motionLightSwitch4UI.setOn(false, animated: false)}
        if (self.defaults.boolForKey("nightmode"))  {self.nightModeSwitch.setOn(true, animated: true) } else {self.nightModeSwitch.setOn(false, animated: false)}
        if (self.defaults.boolForKey("nightmodeatnight"))  {self.nightModeAtNightSwitch.setOn(true, animated: true) } else {self.nightModeAtNightSwitch.setOn(false, animated: false)}
        
        
         //^^ Abolutely no idea why i'm putting it here as opposed to viewdidload.But it's not a mistake


        
    }

    /***************************************************************************************************/

  
    @IBOutlet weak var textFieldLink1: UITextField!
    @IBAction func textFieldLink1Edited(sender: AnyObject) {
        if (self.textFieldLink1.text == ""){
            vc.defaults.setValue(vc.switch1link, forKeyPath: "switch1")
        } else {
            vc.defaults.setValue(self.textFieldLink1.text, forKeyPath: "switch1")
        }
        //print(self.textFieldLink1.text)
    }
    
    @IBOutlet weak var textFieldLink2: UITextField!
    @IBOutlet weak var textFieldLink3: UITextField!
    @IBOutlet weak var textFieldLink4: UITextField!
    @IBOutlet weak var textFieldLink5: UITextField!
    @IBOutlet weak var textFieldLink6: UITextField!
    @IBOutlet weak var textFieldLink7: UITextField!
    @IBOutlet weak var textFieldLink8: UITextField!
    @IBOutlet weak var textFieldLink9: UITextField!
    @IBOutlet weak var textFieldLink10: UITextField!
    @IBOutlet weak var textFieldLink11: UITextField!
    @IBOutlet weak var textFieldLink12: UITextField!
    @IBOutlet weak var textFieldLink13: UITextField!
    
    
    @IBAction func textFieldLink2Edited(sender: AnyObject) {
        if (self.textFieldLink2.text == ""){
            vc.defaults.setValue(vc.switch2link, forKeyPath: "switch2")
        } else {
            vc.defaults.setValue(self.textFieldLink2.text, forKeyPath: "switch2")
        }
    }
    @IBAction func textFieldLink3Edited(sender: AnyObject) {
        if (self.textFieldLink3.text == ""){
            vc.defaults.setValue(vc.switch3link, forKeyPath: "switch3")
        } else {
            vc.defaults.setValue(self.textFieldLink3.text, forKeyPath: "switch3")
        }
    }
    @IBAction func textFieldLink4Edited(sender: AnyObject) {
        if (self.textFieldLink4.text == ""){
            vc.defaults.setValue(vc.switch4link, forKeyPath: "switch4")
        } else {
            vc.defaults.setValue(self.textFieldLink4.text, forKeyPath: "switch4")
        }
    }
    @IBAction func textFieldLink5Edited(sender: AnyObject) {
        if (self.textFieldLink5.text == ""){
            vc.defaults.setValue(vc.sleeplink, forKeyPath: "sleeplink")
        } else {
            vc.defaults.setValue(self.textFieldLink5.text, forKeyPath: "sleeplink")
        }
    }
    @IBAction func textFieldLink6Edited(sender: AnyObject) {
        if (self.textFieldLink6.text == ""){
            vc.defaults.setValue(vc.netflixandchilllink, forKeyPath: "netflixandchilllink")
        } else {
            vc.defaults.setValue(self.textFieldLink6.text, forKeyPath: "netflixandchilllink")
        }
    }
    @IBAction func textFieldLink7Edited(sender: AnyObject) {
        if (self.textFieldLink7.text == ""){
            vc.defaults.setValue(vc.locklink, forKeyPath: "locklink")
        } else {
            vc.defaults.setValue(self.textFieldLink7.text, forKeyPath: "locklink")
        }
    }
    @IBAction func textFieldLink8Edited(sender: AnyObject) {
        if (self.textFieldLink8.text == ""){
            vc.defaults.setValue(vc.webcamlink, forKeyPath: "webcamlink")
        } else {
            vc.defaults.setValue(self.textFieldLink8.text, forKeyPath: "webcamlink")
        }
    }
    @IBAction func textFieldLink9Edited(sender: AnyObject) {
        if (self.textFieldLink9.text == ""){
            vc.defaults.setValue(vc.shutdownlink, forKeyPath: "shutdownlink")
        } else {
            vc.defaults.setValue(self.textFieldLink9.text, forKeyPath: "shutdownlink")
        }
    }
    @IBAction func textFieldLink10Edited(sender: AnyObject) {
        if (self.textFieldLink10.text == ""){
            vc.defaults.setValue(vc.vitalsLink, forKeyPath: "vitalsLink")
        } else {
            vc.defaults.setValue(self.textFieldLink10.text, forKeyPath: "vitalsLink")
        }
    }
    @IBAction func textFieldLink11Edited(sender: AnyObject) {
        if (self.textFieldLink11.text == ""){
            vc.defaults.setValue(vc.homelink, forKeyPath: "homelink")
        } else {
            vc.defaults.setValue(self.textFieldLink11.text, forKeyPath: "homelink")
        }
    }
    @IBAction func textFieldLink12Edited(sender: AnyObject) {
        if (self.textFieldLink12.text == ""){
            vc.defaults.setValue(vc.nothomelink, forKeyPath: "nothomelink")
        } else {
            vc.defaults.setValue(self.textFieldLink12.text, forKeyPath: "nothomelink")
        }
    }
    @IBAction func textFieldLink13Edited(sender: AnyObject) {
        if (self.textFieldLink13.text == ""){
            vc.defaults.setValue(vc.weatherlink, forKeyPath: "weatherlink")
        } else {
            vc.defaults.setValue(self.textFieldLink13.text, forKeyPath: "weatherlink")
        }
    }
    
    
    
    /*****************************************/

    
    @IBAction func motionLightswitch1(sender: AnyObject) {
        if (motionLightSwitch1UI.on){
            swiftRequest.post(vc.motionlightlink, data: ["key":"11"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        } else {
            swiftRequest.post(vc.motionlightlink, data: ["key":"10"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        }
    }
    @IBAction func motionLightswitch2(sender: AnyObject) {
        if (motionLightSwitch2UI.on){
            swiftRequest.post(vc.motionlightlink, data: ["key":"21"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        } else {
            swiftRequest.post(vc.motionlightlink, data: ["key":"20"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        }
    }
    @IBAction func motionLightswitch3(sender: AnyObject) {
        if (motionLightSwitch3UI.on){
            swiftRequest.post(vc.motionlightlink, data: ["key":"31"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        } else {
            swiftRequest.post(vc.motionlightlink, data: ["key":"30"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        }
    }
    @IBAction func motionLightswitch4(sender: AnyObject) {
        if (motionLightSwitch4UI.on){
            swiftRequest.post(vc.motionlightlink, data: ["key":"41"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        } else {
            swiftRequest.post(vc.motionlightlink, data: ["key":"40"], callback: {err, response, body in      //May change link to defaults.
                if( err == nil ) {print(body)}
            })
        }
    }
    
    
    
    @IBOutlet weak var motionLightSwitch1UI: UISwitch!
    @IBOutlet weak var motionLightSwitch2UI: UISwitch!
    @IBOutlet weak var motionLightSwitch3UI: UISwitch!
    @IBOutlet weak var motionLightSwitch4UI: UISwitch!
    @IBOutlet weak var webcamStatusIcon: UIImageView!
    @IBOutlet weak var noiseLevel: UILabel!
    @IBOutlet weak var lightLevelLabel: UILabel!
    @IBOutlet weak var humidityLevelLabel: UILabel!
    @IBOutlet weak var uptimeLabel: UILabel!
    @IBOutlet weak var pingsLabel: UILabel!
    
    @IBAction func lockPCButton(sender: AnyObject) {
        if let temp = self.defaults.stringForKey("locklink") {
            vc.getRequest(temp)
        } else {
            vc.getRequest(vc.locklink)
        }
        
    }    
    @IBOutlet weak var inIthaca: UISwitch!
    
    @IBAction func inIthacaButton(sender: AnyObject) {
        defaults.setBool(inIthaca.on, forKey: "inIthaca")
    }
    
    
    
    func updateStats(){
        if (vc.webcamstatus == "play" ){webcamStatusIcon.image = UIImage(named: "play")}
        else {
            webcamStatusIcon.image = UIImage(named: "pause")
        }
        noiseLevel.text = "\(defaults.objectForKey("noise") as! Float)"
        lightLevelLabel.text = "\(defaults.objectForKey("light") as! Float)"
        uptimeLabel.text = defaults.objectForKey("uptime") as? String
        pingsLabel.text = "\(defaults.objectForKey("pings") as! Int)"
    
    }
    
    @IBAction func deleteGeofence(sender: AnyObject) {
        
        if let archivedRegion = defaults.objectForKey("region") as? NSData {
            
            let alertController = UIAlertController(title: "Are you Sure?", message:
               "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive){ action -> Void in
                self.locationManager.stopMonitoringForRegion(NSKeyedUnarchiver.unarchiveObjectWithData(archivedRegion ) as! CLRegion);
                showSimpleAlertWithTitle("Geofence Deleted", message: "", viewController: self)
                self.defaults.setValue(nil, forKeyPath: "region")
                print(self.defaults.valueForKey("region"))
                }
                
            )
            self.presentViewController(alertController, animated: true, completion: nil)

        
        } else {
            showSimpleAlertWithTitle("There's no region to delete", message: "", viewController: self)

        }

    }
    
    @IBOutlet var geoRadius: UITextField!
    

    @IBAction func geoRadiusEdited(sender: AnyObject) {
        print(geoRadius.text)
        defaults.setDouble((geoRadius.text! as NSString).doubleValue, forKey: "radius")
    }
   
 
    func dismissKeyboard(){
    view.endEditing(true)
    }
    
    
    @IBOutlet weak var nightModeSwitch: UISwitch!
    @IBOutlet weak var nightModeAtNightSwitch: UISwitch!
    @IBAction func nightModeSwitchAction(sender: AnyObject) {
        if nightModeSwitch.on {
            vc.setNightMode(true)
        } else {
            vc.setNightMode(false)
        }
    }
    @IBAction func nightModeAtNightSwitchAction(sender: AnyObject) {
        if nightModeAtNightSwitch.on {
            vc.setNightModeAtNight(true)
        } else {
            vc.setNightModeAtNight(false)
        }
    }
    
    
  
    
    // MARK: - Table view data source
 /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }*/

}
