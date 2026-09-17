//
//  AppDelegate.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit
import SDWebImageSVGCoder
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sliderHide: Bool = false
    var sliderMenuView : SliderMenuView!
    var sliderBakckground = UIView()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        
        // keyboard manager...
//        VKKeyboardManager.shared.setEnable()
        
        // APIs allocation...
//        VKAPIs.shared.basicURL = TMX_Base_URL
        // user existed...

        // stating objects...
        self.startingInformationMethod()
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        return true
    }
//    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      }
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

extension AppDelegate {
    
    // MARK:- Helpers
    func startingInformationMethod() -> Void {
        
        // keyboard manager...
        VKKeyboardManager.shared.setEnable()
        
        // APIs allocation...
        VKAPIs.shared.basicURL = TMX_Base_URL
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error != nil || user == nil {
//            } else {
//                GIDSignIn.sharedInstance.signOut()
////                self.moveToHomeScreen()
//            }
//          }
        // user existed...
        let user_profile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        print("Profile: \(String(describing: user_profile))")

        if user_profile != nil {

            // move to home(Change root for window)...
            moveToHomeScreen()
            moveToHomeTabBarScreen()

        }
    }
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
//        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])

        var _ra: Bool

//      handled = GIDSignIn.sharedInstance.handle(url)
//      if handled {
//        return true
//      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    func moveToHomeTabBarScreen() {
        
        // move to home(Change root for window)...
        let tabBarVC = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HomeTabBarVC") as! HomeTabBarVC
        let navi_ctrl = UINavigationController.init(rootViewController: tabBarVC)
        navi_ctrl.isNavigationBarHidden = true
        window?.rootViewController = navi_ctrl
    }
    func moveToHomeScreen() {
        
        // move to home(Change root for window)...
        let home_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HomeTabBarVC") as! HomeTabBarVC
        let navi_ctrl = UINavigationController.init(rootViewController: home_vc)
        navi_ctrl.isNavigationBarHidden = true
       //kWindow?.rootViewController = navi_ctrl
        if let window = UIApplication.shared.currentWindow {
            window.rootViewController = navi_ctrl
        }
    }
    func moveToLoginScreen() {
        
        // move to home(Change root for window)...
        let home_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navi_ctrl = UINavigationController.init(rootViewController: home_vc)
        navi_ctrl.isNavigationBarHidden = true
       //kWindow?.rootViewController = navi_ctrl
        if let window = UIApplication.shared.currentWindow {
            window.rootViewController = navi_ctrl
            window.makeKeyAndVisible()
        }
    }
    func sideMenu_actions() -> Void {
        
        // getting view...
        let side_menu = self.window?.viewWithTag(50000) as! SliderMenuView
        window?.bringSubviewToFront(side_menu)
        
        if self.sliderHide == false {
            
            // hidden...
            self.sliderHide = true
            UIView.animate(withDuration: 0.5) {
                side_menu.btn_bg.alpha = 1
                side_menu.frame = CGRect.init(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: UIScreen.main.bounds.size.height)
            }
        } else {
            
            // visible...
            self.sliderHide = false
            UIView.animate(withDuration: 0.5) {
                side_menu.btn_bg.alpha = 0
                side_menu.frame = CGRect.init(x: -UIScreen.main.bounds.size.width,
                                              y: 0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: UIScreen.main.bounds.size.height)
            }
        }
    }
}

extension UIApplication {
    
    var currentWindow: UIWindow? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
}

