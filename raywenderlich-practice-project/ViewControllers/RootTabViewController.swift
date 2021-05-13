//
//  RootTabViewController.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import UIKit

class RootTabViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // the three tabs - Library (List), Downloads, Settings
        let libraryViewController = UINavigationController(rootViewController: ListViewController())
        libraryViewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "x"), tag: 0)
        libraryViewController.navigationBar.prefersLargeTitles = true
        libraryViewController.navigationItem.largeTitleDisplayMode = .always
        
        let downloadsViewController = UINavigationController(rootViewController: DownloadsViewController())
        downloadsViewController.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "circle.x"), tag: 1)
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "circle.42"), tag: 2)
        
        self.setViewControllers([libraryViewController, downloadsViewController, settingsViewController], animated: true)
        
        self.selectedViewController = libraryViewController
    }

}
