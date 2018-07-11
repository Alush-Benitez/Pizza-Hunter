//
//  ViewController.swift
//  Pizza Hunter
//
//  Created by Alush Benitez on 7/11/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var region = MKCoordinateRegion()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.025, 0.025)
        region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }


}

