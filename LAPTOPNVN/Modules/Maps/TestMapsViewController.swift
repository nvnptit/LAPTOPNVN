//
//  TestMapsViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/10/2022.
//

import UIKit
import MapKit
import CoreLocation

class TestMapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet var textFieldForAddress: UITextField!
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var map: MKMapView!
    
    var locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.desiredAccuracy=kCLLocationAccuracyBest
        locationManger.requestAlwaysAuthorization()
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        map.delegate = self
    }
    
    @IBAction func getDirectionsTapped (_ sender: Any){
        getAddress()
    }
    
    func getAddress(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textFieldForAddress.text!){(placemarks,error)in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                print ("No Location Found")
                return
            }
            print (location)
            self.mapThis (destinationCord: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (locations)
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D) {
        let souceCordinate = (locationManger.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark (coordinate: souceCordinate)
        let destPlaceMark = MKPlacemark (coordinate: destinationCord)
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem (placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections (request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print ("Something is wrong : (")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect (route.polyline.boundingMapRect, animated: true)
            
            // Pin Maps
            let annotation1 = MKPointAnnotation()
            annotation1.coordinate = souceCordinate
            annotation1.title = "Vị trí của hiện tại của bạn"
            self.map.addAnnotation(annotation1)
            
            let annotation2 = MKPointAnnotation()
            annotation2.coordinate = destinationCord
            annotation2.title = "Vị trí nơi giao hàng"
            self.map.addAnnotation(annotation2)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer (overlay: overlay as! MKPolyline)
        render.strokeColor = .cyan
        return render
    }
    
}
