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
import SafariServices

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var search2 = ""
    var selectedMapItem = MKMapItem()
    var mapItems = [MKMapItem]()
    
    
    var region = MKCoordinateRegion()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        infoView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.025, 0.025)
        region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        loadOptions()
    }

    @IBAction func searchButtonClicked(_ sender: Any) {
        displayMesage(message: "Search for a place")
    }
    
    
    func displayMesage(message:String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let insertAction = UIAlertAction(title: "Search", style: .default) { (action) in
            let searchTextField = alert.textFields![0] as UITextField
            self.search2 = searchTextField.text!
            self.loadOptions()
        }
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        infoView.layer.cornerRadius = 20
        titleLabel.text = selectedMapItem.name!
        phoneNumberLabel.text = selectedMapItem.phoneNumber
        var address = selectedMapItem.placemark.subThoroughfare! + " "
        address += selectedMapItem.placemark.thoroughfare! + "\n"
        address += selectedMapItem.placemark.locality! + ", "
        address += selectedMapItem.placemark.administrativeArea! + " "
        address += selectedMapItem.placemark.postalCode!
        addressLabel.text = address
        infoView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
            }
        }
        //print(selectedMapItem.name!)
    }
    
    
    
    func loadOptions() {
        
        for annotation in mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = search2
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    for mapItem in response.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = mapItem.placemark.coordinate
                        annotation.title = mapItem.name
                        self.mapView.addAnnotation(annotation)
                        self.mapItems.append(mapItem)
                    }
                }
            }
        }
    }
}

