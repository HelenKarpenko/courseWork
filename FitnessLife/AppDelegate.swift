//
//  AppDelegate.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let db = DataBase.shared
//        db.start()

        let realm = try! Realm()
        let folderPath = realm.configuration.fileURL!.path
        print("Realm: Folder Path: \(folderPath)")
////
////        let client1 = Client()
////        client1.id = 1
////        client1.fullName = "James Bond"
////        let client2 = Client()
////        client2.id = 2
////        client2.fullName = "Vasiliy Petrov"
////
        // Persist your data easily
//        try! realm.write {
//            for lesson in db.lessonTemplates.values {
//                realm.add(lesson)
//            }
//            for scheduleItem in db.scheduleItems.values {
//                realm.add(scheduleItem)
//            }
//            for coach in db.OLDCoaches.values {
//                realm.add(coach)
//            }
//            for client in db.clients.values {
//                realm.add(client as! Object)
//            }
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

