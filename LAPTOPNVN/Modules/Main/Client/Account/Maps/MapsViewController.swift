//
//  MapsViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/10/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var coordinate: CLLocationCoordinate2D?
    var dataHistory: [HistoryOrder1] = []
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.zoomToUserLocation(latitudinalMeters: 1, longitudinalMeters: 1)
        if address != "" {
            loadMap()
        }else {
            loadFulLMap()
        }
    }
    func loadFulLMap(){
        for item in dataHistory {
            guard let address = item.diachi, let id = item.idgiohang else {return }
            LocationManager.shared.forwardGeocoding(address: address.lowercased(), completion: {
                    success,coordinate in
                    if success {
                        guard let co = coordinate else {return}
                        self.mapThis (destinationCord: co,address: "\(id)")
                    } else {
                        print("error sth went wrong")
                    }
                })
        }
    }
    func loadMap(){
        LocationManager.shared.forwardGeocoding(address: address.lowercased(), completion: {
            success,coordinate in
            if success {
                guard let co = coordinate else {return}
                self.mapThis (destinationCord: co,address: "")
            } else {
                print("error sth went wrong")
            }
        })
    }
    func mapThis(destinationCord: CLLocationCoordinate2D, address: String) {
        if let souceCordinate = LocationManager.shared.getCurrentLocation()?.coordinate {
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
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect (route.polyline.boundingMapRect, animated: true)
                
                // Pin Maps
                let annotation1 = MKPointAnnotation()
                annotation1.coordinate = souceCordinate
                annotation1.title = "Vị trí của hiện tại của bạn"
                self.mapView.addAnnotation(annotation1)
                
                let annotation2 = MKPointAnnotation()
                annotation2.coordinate = destinationCord
                if (address != ""){
                    annotation2.title = "Vị trí giao đơn hàng \(address)"
                }else {
                    annotation2.title = "Vị trí nơi giao hàng"
                }
                self.mapView.addAnnotation(annotation2)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer (overlay: overlay as! MKPolyline)
        render.strokeColor = UIColor.random()
        return render
    }
    
}
