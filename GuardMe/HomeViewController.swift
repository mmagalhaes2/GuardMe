//
//  HomeViewController.swift
//  GuardMe
//
//  Created by Matheus Magalhães on 8/31/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var totalCard: UIView!
    @IBOutlet weak var monthCard: UIView!
    @IBOutlet weak var totalCccurrence: UILabel!
    @IBOutlet weak var mouthOccurrence: UILabel!
    
    override func loadView() {
        super.loadView()
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        totalCard.layer.cornerRadius = 10
        monthCard.layer.cornerRadius = 10
        
        calculateStatistics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismiss(animated: false, completion: nil)
    }
    
    func calculateStatistics() {
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(
                forResource: "OcorrenciaMensal",
                withExtension: "json"
            ) {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                
                if let object = json as? [[String: Any]] {
                    var total: Int = 0
                    var month: Int = 0
                    
                    for item in object {
                        if let totalOccurrence = item["Total"] as? Int {
                            total += totalOccurrence
                        }
                        if let monthOccurrence = item["Julho"] as? Int {
                            month += monthOccurrence
                        }
                    }
                    
                    totalCccurrence.text = String(total)
                    mouthOccurrence.text = String(month)
                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error)
        }
    }
}
