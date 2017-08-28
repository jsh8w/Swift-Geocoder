//
//  LocationManager.swift
//  Coordinate Converter
//
//  Created by James Shaw on 24/12/2016.
//  Copyright © 2016 James Shaw. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let sharedManager = LocationManager()

    // Address to Coordinates
    func getCoordinatesWith(address: String, completionHandler: ((Float?, Float?, Error?) -> Void)?) {

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in

            if let placemark = placemarks?.first, error == nil {

                let latitude = Float(placemark.location!.coordinate.latitude)
                let longitude = Float(placemark.location!.coordinate.longitude)

                completionHandler?(latitude, longitude, nil)
            }
            else {
                if let error = error {
                    completionHandler?(nil, nil, error)
                } else {
                    completionHandler?(nil, nil, nil)
                }
            }
        })

    }

    // Coordinates to Address
    func getAddressWith(latitude: Float, longitude: Float, completionHandler: ((String?, Error?) -> Void)?) {

        let location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarksFound, error) -> Void in

            guard let placemarks = placemarksFound, error == nil else {
                completionHandler?(nil, error)
                return
            }

            guard placemarks.count > 0 else {
                completionHandler?(nil, nil)
                return
            }

            let placemark = placemarks[0]
            var address: String?

            if let city = placemark.locality {
                if let street = placemark.thoroughfare {
                    if let streetNumber = placemark.subThoroughfare {
                        address = "\(streetNumber) \(street), \(city)"
                    }
                    else {
                        address = "\(street), \(city)"
                    }
                }
                else {
                    address = city
                }
            }

            completionHandler?(address, nil)
        })
    }
}
