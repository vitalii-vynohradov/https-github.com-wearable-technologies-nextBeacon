//
//  MKCoordinateRegion+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 27.01.2022.
//  Source: https://gist.github.com/dionc/46f7e7ee9db7dbd7bddec56bd5418ca6

import MapKit

extension MKCoordinateRegion {
    init?(coordinates: [CLLocationCoordinate2D]) {
        // first create a region centered around the prime meridian
        let primeRegion = MKCoordinateRegion.region(for: coordinates, transform: { $0 }, inverseTransform: { $0 })

        // next create a region centered around the 180th meridian
        let transformedRegion = MKCoordinateRegion.region(for: coordinates, transform: MKCoordinateRegion.transform, inverseTransform: MKCoordinateRegion.inverseTransform)

        // return the region that has the smallest longitude delta
        if let aaa = primeRegion,
           let bbb = transformedRegion,
           let min = [aaa, bbb].min(by: { $0.span.longitudeDelta < $1.span.longitudeDelta }) {
            self = min
        } else if let aaa = primeRegion {
            self = aaa
        } else if let bbb = transformedRegion {
            self = bbb
        } else {
            return nil
        }
    }

    // Latitude -180...180 -> 0...360
    private static func transform(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if coordinate.longitude < 0 { return CLLocationCoordinate2DMake(coordinate.latitude, 360 + coordinate.longitude) }
        return coordinate
    }

    // Latitude 0...360 -> -180...180
    private static func inverseTransform(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if coordinate.longitude > 180 { return CLLocationCoordinate2DMake(coordinate.latitude, -360 + coordinate.longitude) }
        return coordinate
    }

    private typealias Transform = (CLLocationCoordinate2D) -> (CLLocationCoordinate2D)

    private static func region(for coordinates: [CLLocationCoordinate2D], transform: Transform, inverseTransform: Transform) -> MKCoordinateRegion? {
        // handle empty array
        guard !coordinates.isEmpty else { return nil }

        // handle single coordinate
        guard coordinates.count > 1 else {
            return MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        }

        let transformed = coordinates.map(transform)

        // find the span
        let minLat = transformed.min { $0.latitude < $1.latitude }!.latitude
        let maxLat = transformed.max { $0.latitude < $1.latitude }!.latitude
        let minLon = transformed.min { $0.longitude < $1.longitude }!.longitude
        let maxLon = transformed.max { $0.longitude < $1.longitude }!.longitude

        let diffLon = maxLon - minLon
        let diffLat = maxLat - minLat

        // add padding
        let deltaLon = diffLon + diffLon * 0.25
        let deltaLat = diffLat + diffLat * 0.25

        let span = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon)

        // find the center of the span
        let center = inverseTransform(CLLocationCoordinate2D(latitude: (maxLat - diffLat / 2), longitude: maxLon - diffLon / 2))

        return MKCoordinateRegion(center: center, span: span)
    }
}
