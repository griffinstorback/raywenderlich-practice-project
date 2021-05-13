//
//  SettingsViewController.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import UIKit

class SettingsViewController: UIViewController {
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        // Do any additional setup after loading the view.
    }
}
