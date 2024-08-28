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

class ViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var button: UIButton!

    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as [NSNumber]

    override func loadView() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(
            withLatitude: -23.568986189122366,
            longitude: -46.633176282048225,
            zoom: 12
        )
          
        mapView = GMSMapView.init(options: options)
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView.delegate = self
        
        self.view = mapView
    }

    override func viewDidLoad() {
        // Set heatmap options.
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 20
        heatmapLayer.opacity = 1
        heatmapLayer.maximumZoomIntensity = 1000
//        heatmapLayer.minimumZoomIntensity = 10
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints,
                                            colorMapSize: 256)
        //        prepareFile()
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
                forResource: "target",
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

    func mapView(
        _ mapView: GMSMapView,
        didTapAt coordinate: CLLocationCoordinate2D
    ) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    struct Target: Codable {
        let name: String
        let latitude: Double
        let longitude: Double
    }
    
    //    func prepareFile() -> StorageReference {
    //        let storage = Storage.storage()
    //        
    //        let gsReference = storage.reference(
    //            forURL: "gs://guardme-433722.appspot.com/target.json"
    //        ).getData(maxSize: 100 * 1024 * 1024) { data, error in
    //            if let error = error {
    //                // Uh-oh, an error occurred!
    //                print(error)
    //            } else {
    //                // Data for "images/island.jpg" is returned
    //                print(data!.absoluteString)
    //            }
    //        }
    //        
    //        return gsReference
    //    }
            
}

