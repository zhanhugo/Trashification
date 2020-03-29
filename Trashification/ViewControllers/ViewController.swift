//
//  ViewController.swift
//  Trashification
//
//  Created by Hugo Zhan on 3/28/20.
//  Copyright © 2020 Tim's Apples. All rights reserved.
//
import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video in the background
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }

}

