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

class Points: NSObject {
    var longitude: Double
    var city: String
    var address: String
    var phone: String
    var trade_point: String
    var latitude: Double
    
    init(city: String, address: String, trade_point: String, phone: String, longitude: Double, latitude: Double) {
        self.city = city
        self.address = address
        self.trade_point = trade_point
        self.phone = phone
        self.longitude = longitude
        self.latitude = latitude
        super.init()
    }
}


class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var initialLocation = CLLocationCoordinate2D(latitude: 48.704360,
                                                 longitude: 44.509449)
    
    var points: [Points] = []
    var nearPoints: [Points] = []
    
    var locate: [CLLocation] = []
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tbl: UITableView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btnReconnect: UIButton!
    
    @IBAction func OpenSite(sender: UIButton) {
        if let url = NSURL(string: "https://wildberries.ru"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func WorkWithJSON(){
        points.append(Points(city: "",address: "",trade_point: "WILDBERRIELS",phone: "",longitude: 0.0,latitude: 0.0))
        nearPoints.append(Points(city: "",address: "",trade_point: "WILDBERRIELS",phone: "",longitude: 0.0,latitude: 0.0))
        if let path = NSBundle.mainBundle().pathForResource("points", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let point : [NSDictionary] = jsonResult["points"] as? [NSDictionary] {
                        for Point: NSDictionary in point {
                            var address = Point.valueForKey("address")
                           address!.dataUsingEncoding(NSUTF8StringEncoding)
                            if let d = address {
                                
                            points.append(Points(city: "\(Point.valueForKey("city"))",address: d as! String,trade_point: "\(Point.valueForKey("trade_point")!)",phone: "\(Point.valueForKey("phone")!)",longitude: (Point.valueForKey("coord_last_latitude") as? Double)! ,latitude:(Point.valueForKey("coord_first_longtitude") as? Double)!))
                                
                                
                            }
                        }
                    }
                } catch {}
            } catch {}
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkWithJSON()
        if(Reachability.isConnectedToNetwork()==true){
            tbl.delegate = self
            tbl.dataSource = self
            
            map.delegate = self
            // Ask for Authorisation from the User.
            if #available(iOS 8.0, *) {
                self.locationManager.requestAlwaysAuthorization() //8
            
            
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization() //8

                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.map.showsUserLocation = true
                    locationManager.startUpdatingLocation() //8
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: initialLocation, span: span)
                    map.setRegion(region, animated: true)
                    
                    //setCenterOfMapToLocation(initialLocation)
                }
                
            } else {
                // Fallback on earlier versions
            }
            //addPinToMapView()
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
        locate = locations
        addPinToMapView()
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
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
    
    private func addPinToMapView() {
        if locate.isEmpty {
            nearPoints = points
            updateTable()
        } else {
            if nearPoints.count > 1 {
                return
            }
            
            var isFind = false
            for point in points {
                if point.latitude != 0 && point.longitude != 0 {
                    let location = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    
                    if locate.last?.distanceFromLocation(CLLocation(latitude: point.latitude, longitude: point.longitude)) < 100000 {
                        let annotation = CustomAnnotation()
                        isFind = true
                        annotation.coordinate = location
                        annotation.title = point.trade_point + "\nАдрес: " + point.address
                        map.addAnnotation(annotation)
                        nearPoints.append(point)
                    }
                }
            }
            
            updateTable()
            
            if !isFind {
                nearPoints = points
                updateTable()
                
                for point in nearPoints {
                    if point.latitude != 0 && point.longitude != 0 {
                        let location = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                        let annotation = CustomAnnotation()
                        annotation.coordinate = location
                        annotation.title = point.trade_point + "\nАдрес: " + point.address
                        map.addAnnotation(annotation)
                    }
                }
            }
        }
    }


    func updateTable()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tbl.reloadData()
        })
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
    
    override func viewDidDisappear(animated: Bool) {
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        map.removeFromSuperview()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        return nearPoints.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if nearPoints[indexPath.row].trade_point == "WILDBERRIELS" {
            let cell = tableView.dequeueReusableCellWithIdentifier("WildCell", forIndexPath: indexPath) as! TableViewCell
            cell.textLabel?.text = "WILDBERRIELS"
            cell.detailTextLabel?.text = "интернет-магазин"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MagCell", forIndexPath: indexPath)
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: nearPoints[indexPath.row].trade_point + "\nАдрес: " + nearPoints[indexPath.row].address, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 14.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSRange(location:nearPoints[indexPath.row].trade_point.characters.count+8,length:nearPoints[indexPath.row].address.characters.count))
            cell.textLabel?.attributedText = myMutableString
            return cell
        }
    }
}
