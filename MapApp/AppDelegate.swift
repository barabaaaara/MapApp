//
//  AppDelegate.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/02/21.
//

import UIKit
import Firebase
import GoogleMaps
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBSqzM8DB6-qHJ-OhXGkwdb5GOcismgjV4")

        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        return true
    }
}

