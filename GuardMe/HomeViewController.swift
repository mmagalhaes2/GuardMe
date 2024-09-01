//
//  HomeViewController.swift
//  GuardMe
//
//  Created by Matheus Magalhães on 8/31/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var test: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.layer.cornerRadius = 10
    }
}
