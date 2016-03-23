//
//  BuyTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MyAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
    
}

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mags = ["WILDBERRIELS","ТРЦ \"Пирамида\", 2 этаж","м-н \"40 недель\""]
    let mags0 = ["","ул. Краснознаменская, 9","ул. Ленина, 19"]
    let magsLoc = [0,48.704360,48.706817]
    let magsLoc0 = [0,44.509449,44.510901]
    var locationManager = CLLocationManager()
    var initialLocation = CLLocationCoordinate2D(latitude: 48.704360,
                                                 longitude: 44.509449)
    
    

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tbl: UITableView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btnReconnect: UIButton!
    
    @IBAction func OpenSite(sender: UIButton) {
        if let url = NSURL(string: "https://wildberries.ru"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //map = MKMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Reachability.isConnectedToNetwork()==true){
            tbl.delegate = self
            tbl.dataSource = self
            
            //checkLocationAuthorizationStatus()
            map.delegate = self
            
            // Ask for Authorisation from the User.
            if #available(iOS 8.0, *) {
                self.locationManager.requestAlwaysAuthorization() //8
            
            
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization() //8
            
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    //self.map.showsUserLocation = true
                    //locationManager.startUpdatingLocation() //8
                    setCenterOfMapToLocation(initialLocation)
                }
                
            } else {
                // Fallback on earlier versions
            }
            addPinToMapView()
            
        }
        else{
            map.hidden = true
            label.hidden=false
            btnReconnect.hidden=false
            btnReconnect.enabled=true
        }
 
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.map.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    /* We have a pin on the map, now zoom into it and make that pin
     the center of the map */
    func setCenterOfMapToLocation(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
    }
    
    func addPinToMapView(){
        var i = Int(1)
        while i < magsLoc.count {
            /* This is just a sample location */
            let location = CLLocationCoordinate2D(latitude: magsLoc[i],
                                                  longitude: magsLoc0[i])
        
           
            /* Create the annotation using the location */
            /*let annotation = MyAnnotation(coordinate: location,
                                          title: mags[i],
                                          subtitle: "Адрес: " + mags0[i])*/
            let annotation = CustomAnnotation()
            annotation.coordinate = location
            annotation.title = mags[i] + "\nАдрес: " + mags0[i]
            /* And eventually add it to the map */
            map.addAnnotation(annotation)
            i = i+1
        }
    }

    
    
    // define annotation view identifiers
    
    let calloutAnnotationViewIdentifier = "CalloutAnnotation"
    let customAnnotationViewIdentifier = "MyAnnotation"
    
    // If `CustomAnnotation`, show standard `MKPinAnnotationView`. If `CalloutAnnotation`, show `CalloutAnnotationView`.
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(customAnnotationViewIdentifier)
            if pin == nil {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
                pin?.canShowCallout = false
            } else {
                pin?.annotation = annotation
            }
            return pin
        } else if annotation is CalloutAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(calloutAnnotationViewIdentifier)
            if pin == nil {
                pin = CalloutAnnotationView(annotation: annotation, reuseIdentifier: calloutAnnotationViewIdentifier)
                pin?.canShowCallout = false
            } else {
                pin?.annotation = annotation
            }
            return pin
        }
        
        return nil
    }
    
    // If user selects annotation view for `CustomAnnotation`, then show callout for it. Automatically select
    // that new callout annotation, too.
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            let calloutAnnotation = CalloutAnnotation(annotation: annotation)
            mapView.addAnnotation(calloutAnnotation)
      
            dispatch_async(dispatch_get_main_queue()) {
                mapView.selectAnnotation(calloutAnnotation, animated: false)
            }
        }
    }
    
    /// If user unselects callout annotation view, then remove it.
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? CalloutAnnotation {
            mapView.removeAnnotation(annotation)
            
            //mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {

    }
    
    override func viewDidDisappear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mags.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if mags[indexPath.row] == "WILDBERRIELS" {
            //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "WildCell") as! TableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("WildCell", forIndexPath: indexPath) as! TableViewCell
            //cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
            cell.textLabel?.text = "WILDBERRIELS"
            cell.detailTextLabel?.text = "интернет-магазин"
            return cell
        } else {
            //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "MagCell") as! TableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("MagCell", forIndexPath: indexPath)
            //cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
            //cell.textLabel?.numberOfLines = 2
            //cell.textLabel?.text = mags[indexPath.row] + "\nАдрес: "
            //cell.detailTextLabel?.text=mags0[indexPath.row]
            //cell.detailTextLabel?.textColor = .blueColor()
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: mags[indexPath.row] + "\nАдрес: " + mags0[indexPath.row], attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 14.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSRange(location:mags[indexPath.row].characters.count+8,length:mags0[indexPath.row].characters.count))
            cell.textLabel?.attributedText = myMutableString
            return cell
        }
    }
}
