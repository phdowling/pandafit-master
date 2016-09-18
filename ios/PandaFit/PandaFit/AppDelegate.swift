//
//  AppDelegate.swift
//  PandaFit
//
//  Created by Felix Sonntag on 16/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit
import HealthKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthKitManager:PGHealthKitManager = PGHealthKitManager()
    let networkController:PGNetworkController = PGNetworkController()
    let demo = true
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.activate()
        }
        
        // Override point for customization after application launch.
        authorizeHealthKit()
        
        let level = UserDefaults.standard.value(forKey: "level")
        UserDefaults.standard.set(demo, forKey: "demo")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if level != nil {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
            self.window?.rootViewController = initialViewController

        } else {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
            self.window?.rootViewController = initialViewController

        }
        
        self.window?.makeKeyAndVisible()
        
        DispatchQueue.global(qos: .background).async {
            while true {
                self.retrieveAndPostSteps()
                sleep(5)
            }
        }
        
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
    
    func authorizeHealthKit() {
        healthKitManager.authorizeHealthKit { (authorized, error) in
            if (authorized) {
                print("Authorized HealthKit")
            } else {
                print("Couldn't authorize HealthKit")
                if (error != nil) {
                    print(error)
                }
                
            }
        }
    }
    
    func retrieveAndPostSteps() {
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            healthKitManager.retrieve(quantityTypeIdentifier: HKQuantityTypeIdentifier.stepCount) { (steps) in
                print(steps)
                self.networkController.postSteps(name: name, numberSteps: Int(steps))
            }
        } else {
            print("Can't post steps, name not set")
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Session activcation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            replyHandler(["name": name])
        } else {
            print("Can't get name for sending as a message")
        }
    }

}

