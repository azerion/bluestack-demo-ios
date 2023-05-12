//
//  AppDelegate.swift
//  DemoSwift
//
//  Created by HtrimechMac on 04/06/2021.
//

import UIKit
import AdSupport
import CoreLocation
import AVFoundation
import BlueStackSDK



@main
class AppDelegate: UIResponder, UIApplicationDelegate,MNGAdsSDKFactoryDelegate {
    var window: UIWindow?
    var drawerViewController : MABDrawerViewController?
    var appDelegateNavigationController : UINavigationController?
    
    var firstCallSplash : Bool = false
    var sharedLocationManager : CLLocationManager?
    
    var player: AVPlayer?
    var playerItem : AVPlayerItem?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //AppID
        if MNG_ADS_APP_ID == nil {
            UserDefaults.standard.set(DemoSwiftConstants.appID, forKey: SavedAppId)
            UserDefaults.standard.synchronize()
        }
        
        //Consent Flag
       if MNG_ADS_ConsentFlag == nil {
            UserDefaults.standard.set(2, forKey: ConsetFlagBlueSTack)
            UserDefaults.standard.synchronize()
        }
        
        //CMP Language
        if MNG_ADS_CMPLanguage == nil {
            UserDefaults.standard.set("fr" ,forKey: CMP_LANGUAGE)
            UserDefaults.standard.synchronize()
        }
        
        //request user location
        if self.sharedLocationManager == nil {
            self.sharedLocationManager = CLLocationManager()
            if self.sharedLocationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))  ?? false {
                self.sharedLocationManager?.requestWhenInUseAuthorization()
            }
            self.sharedLocationManager?.startUpdatingLocation()
        }

        
        let splashVC  = SplashViewController()
        let nav = UINavigationController(rootViewController: splashVC)
        nav.isNavigationBarHidden = true
        
        self.window  = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        //firebase
    
        //Log the value
        let idfaString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("device Id is \(idfaString)")
        self.firstCallSplash = true

       
        return true
    }
    
    //MARK: -transitions
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.firstCallSplash = false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog(self.firstCallSplash ? " ‼️MNGAdsSDKLog Yes" : " ‼️MNGAdsSDKLog No");
        if !(self.window?.rootViewController is SplashViewController) {
            if !self.firstCallSplash {
                InterstitialManager._sharedManager.showInterstitial()
                NSLog("‼️MNGAdsSDKLog firstCallSplash");
            }
            NSLog("‼️MNGAdsSDKLog applicationDidBecomeActive");
        }
    }
    

    
    // MARK: - Player
    
    func play(){
        let url = URL(string: "http://cdn.nrjaudio.fm/audio1/fr/30001/mp3_128.mp3?origine=fluxradios")
        player = AVPlayer(url: url!)
        player?.play()
    }
    
    func stop() {
        player?.pause()
    }
    
    
    //MARK: -Toast
    func displayToast(message : String)  {
        OperationQueue.main.addOperation {
            let keyWindow = UIApplication.shared.keyWindow
            let toastView = UILabel()
            toastView.text = message
            toastView.textColor = .white
            toastView.numberOfLines = 0
            toastView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
            toastView.textAlignment = .center
            toastView.frame = CGRect(x: 0.0, y: 0.0, width: keyWindow!.frame.size.width * 0.75, height: 100)
            toastView.layer.cornerRadius = 10
            toastView.layer.masksToBounds = true
            toastView.center = keyWindow!.center
            
            keyWindow?.addSubview(toastView)
            
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut) {
                toastView.alpha = 0.0
            } completion: { finished in
                toastView.removeFromSuperview()
            }

        }
    }
    
    
}



