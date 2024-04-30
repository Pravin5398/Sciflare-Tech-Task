//
//  HomeVC.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 29/04/24.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerBtn.layer.cornerRadius = 20
        locationBtn.layer.cornerRadius = 20
    }
    
    @IBAction func usersButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showUsers", sender: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showLocation", sender: nil)
    }
    
}
