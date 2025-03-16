//
//  ViewController.swift
//  GeoReminders
//
//  Created by Developer on 14/03/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mapViewControllerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        openMapViewController()
    }
    
    private func openMapViewController () {
        let vc = storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

