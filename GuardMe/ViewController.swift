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
import FirebaseStorage

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var locationManager = CLLocationManager()
    
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.05, 0.5] as [NSNumber]
    
    override func loadView() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(
            withLatitude: -23.568986189122366,
            longitude: -46.633176282048225,
            zoom: 12
        )
        mapView = GMSMapView.init(options: options)
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.view = mapView
        
//        self.mapView?.settings.myLocationButton = true
//        self.mapView.isMyLocationEnabled = true
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        // Set heatmap options.
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 25
        heatmapLayer.opacity = 0.8
        heatmapLayer.maximumZoomIntensity = 500
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints,
                                            colorMapSize: 256)
        addHeatmap()
        
        // Set the heatmap to the mapview.
        heatmapLayer.map = mapView
    }
    
    // Parse JSON data and add it to the heatmap layer.
    func addHeatmap() {
        var list = [GMUWeightedLatLng]()
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(
                forResource: "target2",
                withExtension: "json"
            ) {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                
                if let object = json as? [[String: Any]] {
                    for item in object{
                        let lat = item["LATITUDE"]
                        let lng = item["LONGITUDE"]
                        
                        let coords = GMUWeightedLatLng(
                            coordinate: CLLocationCoordinate2DMake(
                                lat as! CLLocationDegrees,
                                lng as! CLLocationDegrees
                            ),
                            intensity: 1
                        )
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let location = locations.last
//        
//        let coordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 23.568986189122366, longitude: location?.coordinate.longitude ?? 46.633176282048225)
//        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0)
//        self.mapView?.animate(to: camera)
//        
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//        
//    }
    
}

