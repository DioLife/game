//
//  AppDelegate.swift
//  Zombie Piranhas tvOS
//
//  Created by Michael Briscoe on 9/16/16.
//  Copyright © 2016 Razeware, LLC. All rights reserved.
//

import UIKit
import GameController

protocol ReactToMotionEvents {
  func motionUpdate(_ motion: GCMotion) -> Void
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var motionDelegate: ReactToMotionEvents? = nil


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    NotificationCenter.default.addObserver(self, selector: #selector(setupControllers(_:)),
                                           name: NSNotification.Name.GCControllerDidConnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(setupControllers(_:)),
                                           name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    GCController.startWirelessControllerDiscovery(completionHandler: nil)
    
    return true
  }
  
  func setupControllers(_ notification: NSNotification) {
    let controllers = GCController.controllers()
    for controller in controllers {
      controller.motion?.valueChangedHandler =
        { (motion: GCMotion)->() in
          self.motionDelegate?.motionUpdate(motion)
      }
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

