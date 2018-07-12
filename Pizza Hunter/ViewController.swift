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

//42.0516
//-87.6814

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var search2 = ""
    var selectedMapItem = MKMapItem()
    var mapItems = [MKMapItem]()
    
    let food = ["pizza", "sushi", "mexican", "chinese", "indian", "bbq", "BBQ", "barbecue", "seafood", "steak", "lobster", "food", "restauant", "fast food", "breakfast", "lunch", "dinner"]
    let car = ["gas", "car dealership", "dealership", "gas station", "rental cars", "parking"]
    let grocery = ["grocery stores", "grocery"]
    let maintenance = ["car shop", "repair shop"]
    let apple = ["apple store", "apple stores"]
    let star = ["movies", "movie theatre"]
    let sun = ["parks", "park", "garden"]
    
    @NSCopying var markerTintColor: UIColor? = .orange
    
    
    var region = MKCoordinateRegion()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        infoView.alpha = 0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
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
            searchTextField.autocapitalizationType = .words
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
        
        let identifier = ""
        var markerView = MKMarkerAnnotationView()
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            markerView = dequedView
        } else{
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        
        markerView.canShowCallout = true
        markerView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        if food.contains(search2) {
            markerView.glyphImage = UIImage(named: "restaurant")
        } else if car.contains(search2) {
            markerView.glyphImage = UIImage(named: "car")
        } else if grocery.contains(search2) {
            markerView.glyphImage = UIImage(named: "shopping_cart")
        } else if maintenance.contains(search2) {
            markerView.glyphImage = UIImage(named: "maintenance")
        } else if apple.contains(search2) {
            markerView.glyphImage = UIImage(named: "apple")
        } else if star.contains(search2) {
            markerView.glyphImage = UIImage(named: "star")
        } else if sun.contains(search2){
            markerView.glyphImage = UIImage(named: "sun")
        }
        //markerView.glyphTintColor = .black
        //markerView.tintColor = .black
        //markerView.clusteringIdentifier = identifier
        return markerView
        
        /*
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker")
        if markerView == nil {
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            markerView?.canShowCallout = true
            markerView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            markerView?.markerTintColor = markerTintColor
        } else {
            markerView?.annotation = annotation
        }
        return markerView
 */
        return markerView
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
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0.95
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
            }
        }
    }
    

    @IBAction func onWebsiteButtonTapped(_ sender: Any) {
        if let url = selectedMapItem.url {
            present(SFSafariViewController(url: url), animated: true)
        }
    }
    
    
    @IBAction func onDirectionsButtonTapped(_ sender: Any) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: [selectedMapItem], launchOptions: launchOptions)
    }
    
    
    @IBAction func tappedAway(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0
        }
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

