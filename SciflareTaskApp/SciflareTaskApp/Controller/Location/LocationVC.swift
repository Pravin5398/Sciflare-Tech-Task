//
//  LocationVC.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 29/04/24.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

    var locationManager = CLLocationManager()
    var currentPinLocation : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
    }
    
    func setupUI() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    

   
}

extension LocationVC {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentPinLocation = mapView.centerCoordinate
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
//        if let location = locations.first {
//            render(location)
//        }
    }

    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
        // Update latitude and longitude labels
        latLabel.text = "\(coordinate.latitude)"
        longLabel.text = "\(coordinate.longitude)"
    }
}
