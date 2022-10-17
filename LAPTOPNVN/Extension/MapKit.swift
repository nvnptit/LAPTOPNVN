//
//  MapKit.swift
//  LAPTOPNVN
//
//  Created by Nhat on 15/10/2022.
//

import MapKit
import CoreLocation
extension MKMapView {
  func zoomToUserLocation() {
     self.zoomToUserLocation(latitudinalMeters: 1000, longitudinalMeters: 1000)
  }

  func zoomToUserLocation(latitudinalMeters:CLLocationDistance,longitudinalMeters:CLLocationDistance)
  {
    guard let coordinate = userLocation.location?.coordinate else { return }
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    setRegion(region, animated: true)
  }

}
