//
//  ViewController.swift
//  GuardMe
//
//  Created by Matheus Magalhães on 8/26/24.
//

import Foundation
import GoogleMaps
import UIKit
import GoogleMapsUtils

class ViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
      private var heatmapLayer: GMUHeatmapTileLayer!
      private var button: UIButton!

      private var gradientColors = [UIColor.green, UIColor.red]
      private var gradientStartPoints = [0.2, 1.0] as [NSNumber]

      override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -37.848, longitude: 145.001, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView.delegate = self
        self.view = mapView
      }

      override func viewDidLoad() {
        // Set heatmap options.
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 80
        heatmapLayer.opacity = 0.8
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints,
                                            colorMapSize: 256)
        addHeatmap()

        // Set the heatmap to the mapview.
        heatmapLayer.map = mapView
      }

      // Parse JSON data and add it to the heatmap layer.
      func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        do {
          // Get the data: latitude/longitude positions of police stations.
          if let path = Bundle.main.url(forResource: "police_stations", withExtension: "json") {
            let data = try Data(contentsOf: path)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [[String: Any]] {
              for item in object {
                let lat = item["lat"]
                let lng = item["lng"]
                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
                list.append(coords)
              }
            } else {
              print("Could not read the JSON.")
            }
          }
        } catch {
          print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
      }

      func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
      }

}

