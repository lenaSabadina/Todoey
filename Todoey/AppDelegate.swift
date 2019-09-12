//
//  AppDelegate.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-08-26.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
     //   print(Realm.Configuration.defaultConfiguration.fileURL)
                
        do{
            _ = try Realm()
        } catch {
            print("Error initializing realm \(error)")
        }
        return true
    }
}

