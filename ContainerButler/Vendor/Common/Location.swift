//
//  Location.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import MapKit

private let shareInstance = Location()
class Location: NSObject {
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var cityName: String = ""
    static let share: Location = shareInstance
    fileprivate lazy var llocationManager: CLLocationManager = CLLocationManager()
    
    func startLocate() {
        if CLLocationManager.locationServicesEnabled() {
            Location.share.llocationManager.delegate =  Location.share
            Location.share.llocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            Location.share.llocationManager.requestWhenInUseAuthorization()
            Location.share.llocationManager.startUpdatingLocation()
        }
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation: CLLocation = locations.last {
            let location: CLLocation = locations[0]
            let coordinate2D: CLLocationCoordinate2D = location.coordinate
            let baidu: CLLocationCoordinate2D = BD09FromGCJ02(with: coordinate2D)
            Location.share.latitude = baidu.latitude
            Location.share.longitude = baidu.longitude
            let geocoder: CLGeocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (arr, error) in
                guard let arr = arr else { return }
                if !arr.isEmpty {
                    if let placemark: CLPlacemark = arr.first {
                        var currentCity: String = ""
                        if let city: String = placemark.locality {
                            currentCity = city
                        } else {
                            guard let arrea =  placemark.administrativeArea else { return }
                            currentCity = arrea
                        }
                        //                        print("currentCity : \(currentCity)")
                        Location.share.cityName = currentCity
                        if !Location.share.cityName.isEmpty {
                            Location.share.llocationManager.stopUpdatingLocation()
                        }
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        print("error:\(error.localizedDescription)")
    }
    
    fileprivate func BD09FromGCJ02(with coor: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi: CLLocationDegrees = 3.14159265358979324 * 3000.0 / 180.0
        let x: CLLocationDegrees = coor.longitude
        let y: CLLocationDegrees = coor.latitude
        let z: CLLocationDegrees = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta: CLLocationDegrees = atan2(y, x) + 0.000003 * cos(x * x_pi)
        let bd_lon: CLLocationDegrees = z * cos(theta) + 0.0065
        let bd_lat: CLLocationDegrees = z * sin(theta) + 0.006
        return CLLocationCoordinate2DMake(bd_lat, bd_lon)
    }
}
