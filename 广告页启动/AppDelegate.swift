//
//  AppDelegate.swift
//  广告页启动
//
//  Created by 文伟佳 on 2021/11/16.
//

import UIKit

let KEY_NOTIFY_CHANGE_KEY_WINDOW = "KEY_NOTIFY_CHANGE_KEY_WINDOW"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var splashWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        addObserver()
        
        // 多window实现,相当于又2个window，1个在下面，1个在上面
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.tintColor = .darkGray;
        let nav1 = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nav1
        window?.makeKeyAndVisible()
        
//        self.splashWindow = UIWindow(frame: CGRect(x: 0, y: 100, width: 300, height: 500))
        self.splashWindow = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = SplashViewViewController()
        let nav = UINavigationController(rootViewController: splashVC)
        splashWindow?.rootViewController = nav
        splashWindow?.makeKeyAndVisible()
        return true
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeSplashWindow), name: NSNotification.Name.init(rawValue: KEY_NOTIFY_CHANGE_KEY_WINDOW), object: nil)
    }
    
    @objc private func removeSplashWindow() {
        splashWindow?.rootViewController = nil
        splashWindow?.removeFromSuperview()
        splashWindow = nil
        
        //单window实现
//        let nav1 = UINavigationController(rootViewController: ViewController())
//        splashWindow?.rootViewController = nav1
//        splashWindow?.makeKeyAndVisible()

    }
}

