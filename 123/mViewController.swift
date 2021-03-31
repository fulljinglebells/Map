//
//  mViewController.swift
//  123
//
//  Created by Мария Емельянова on 23.10.2020.
//

import UIKit
import MapKit

class mViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ldi: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnable()
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationEnable(){
        if CLLocationManager.locationServicesEnabled(){
            setupManager()
            checkAutorization()
            
        } else {
            
            showAlertLocation(title: "У вас выключена геолокация", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            ldi.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Вы запретили использование местоположение", message: "Хотите это исправить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
    }
    }
    func showAlertLocation (title: String, message: String?, url: URL?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settings = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settings)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension mViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            ldi.setRegion(region, animated: true)
        }
    }
}
    

