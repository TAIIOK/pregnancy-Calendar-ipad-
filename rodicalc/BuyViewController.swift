//
//  BuyTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import MapKit

class Artwork: NSObject, MKAnnotation {
    let Title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.Title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var Subtitle: String {
        return locationName
    }
}

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let mags = ["ТРЦ \"Пирамида\", 2 этаж","м-н \"40 недель\""]
    let mags0 = ["Адрес: ул. Краснознаменская, 9","Адрес: ул. Ленина, 19"]
    
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MagCell")
            
        tbl.delegate = self
        tbl.dataSource = self
        
        // show artwork on map
        /*let artwork = Artwork(title: "King David Kalakaua",
            locationName: "Waikiki Gateway Park",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        map.addAnnotation(artwork)*/
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mags.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MagCell", forIndexPath: indexPath)
        //cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "MagCell")
        //cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
        //cell.textLabel?.numberOfLines = 0
        //cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = mags[indexPath.row]
        //cell.detailTextLabel?.text=mags0[indexPath.row]
        //cell.addSubview(cell.detailTextLabel!)
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        return cell
    }
    
        // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
