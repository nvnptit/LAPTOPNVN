//
//  LocationManager.swift
//  LAPTOPNVN
//
//  Created by Nhat on 07/10/2022.
//

import UIKit
import CoreLocation
import MapKit

typealias LocationCompletion = (CLLocation) -> ()

final class LocationManager: NSObject {

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentLocationCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    private var isUpdatingLocation = false
    
    static let shared = LocationManager()
    var myAdress = ""
    var long = 0.0
    var lat = 0.0
    var length = ""
    
    override init() {
        super.init()
        configLocation()
    }

    func configLocation() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateMyLocation(_ lat: Double, _ long:Double){
        self.lat = lat
        self.long = long
    }
    func forwardGeocoding (address: String, completion:@escaping (Bool, CLLocationCoordinate2D?) -> () ) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address){
            placemarks , error in
            if error != nil {
                print(error?.localizedDescription)
                completion(false,nil)
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    let location = placemark.location
                    completion(true, location?.coordinate)
                    
                }
            }
        }
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
            if #available(iOS 14.0, *) {
                return locationManager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }
        
    func request() {
            let status = getAuthorizationStatus()
            
            if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
                return
            }
            
            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                return
            }
            
            locationManager.requestLocation()
        }

    func showAlertGotoSettings() {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                let message = "Ứng dụng không có quyền sử dụng định vị.\nVui lòng cấp quyền cho ứng dụng ở cài đặt để có thể sử dụng."
                let alertController = UIAlertController (title: "", message: message, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Đi tới cài đặt", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    
    func getCurrentLocation() -> CLLocation? {
//            let status = getAuthorizationStatus()
//            if status == .denied || status == .restricted || status == .notDetermined || !CLLocationManager.locationServicesEnabled() {
//                showAlertGotoSettings()
//                return nil
//            }
            return currentLocation
        }
    
    //Cập nhật vị trí hiện tại của người dùng
    func startUpdatingLocation(completion: @escaping LocationCompletion) {
        locationCompletion = completion
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        isUpdatingLocation = false
        locationManager.stopUpdatingLocation()
    }
    
    //Chuyển đổi từ địa chỉ sang vị trí địa lý
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    //Chuyển đổi từ vị trí địa lý sang địa chỉ
    func getAddressFromLocation(latitude: Double, longitude: Double, completion: @escaping((String?, Error?) -> Void)) {
            var center = CLLocationCoordinate2D()

            let geocoder = CLGeocoder()
            center.latitude = latitude
            center.longitude = longitude

            let loc = CLLocation(latitude:center.latitude, longitude: center.longitude)

            geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                if (error != nil) {
                    completion(nil, error)
                } else if let pm = placemarks, pm.count > 0 {
                    let pm = placemarks![0]

                    var addressString = ""
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + " "
                    }

                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }

                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }

                    if pm.subAdministrativeArea != nil {
                        addressString = addressString + pm.subAdministrativeArea! + ", "
                    }

                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }

                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }

                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    completion(addressString, nil)
                }
            })
        
        }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            
        case .restricted:
            print("parental control setting disallow location data")
            
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            
        default:
            print("default")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
              self.currentLocation = location
            //update long lat my location
            updateMyLocation(location.coordinate.latitude,location.coordinate.longitude)
            
              if let currentCompletion = currentLocationCompletion {
                  currentCompletion(location)
              }
              
              if isUpdatingLocation, let updating = locationCompletion {
                  updating(location)
              }
          }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Error: \(error.localizedDescription)")
     }
    
    
    func getAddressFromLatLon(_ longitude: String,_ latitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        
        center.latitude = Double("\(latitude)")!
        center.longitude = Double("\(longitude)")!
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if (error != nil)
            {
                print("Reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                let name = pm.name ?? ""
                let street = pm.thoroughfare ?? ""
                let ward = pm.subLocality ?? ""
                let city = pm.locality ?? ""
                let country = pm.country ?? ""
                let address = "\(name),\(street),\(ward),\(city),\(country)"
                print ("\(address)")
                self.myAdress = address
            }
        })
        
        return self.myAdress
    }
    
}
