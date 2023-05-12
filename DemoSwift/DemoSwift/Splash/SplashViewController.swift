//
//  SplashViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 24/8/2022.
//

import UIKit
import BlueStackSDK

class SplashViewController: UIViewController , MNGAdsAdapterInterstitialDelegate, MNGClickDelegate, MNGAdsSDKFactoryDelegate {
    
    var interstitialAdsFactory :MNGAdsSDKFactory?
    var navigationCompleted : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let debugmMode  = UserDefaults.standard.bool(forKey: "SavedDebug")
        MNGAdsSDKFactory.setDebugModeEnabled(debugmMode)
        //add this line if you don't like the SDK applies the mixWithOtherAudio
//        MNGAdsSDKFactory.setAudioMixedWithOthersEnabled(false)
        MNGAdsSDKFactory.setDelegate(self)
        MNGAdsSDKFactory.initWithAppId(MNG_ADS_APP_ID ?? DemoSwiftConstants.appID)
        
        print("app id = \(MNG_ADS_APP_ID ?? "There is no AppId")")
        
    }


    //MARK: navigation
    func setUpNavigation() {
        
        //        let homeViewVC  : SwiftViewController  = SwiftViewController.init()
        let homeViewVC  : BannerViewController  = BannerViewController()
        APP_DELEGATE.appDelegateNavigationController = UINavigationController(rootViewController: homeViewVC)
        APP_DELEGATE.appDelegateNavigationController?.isNavigationBarHidden = true
        
        let menuVC  : MenuViewController  = MenuViewController()
        APP_DELEGATE.drawerViewController = MABDrawerViewController(viewController: APP_DELEGATE.appDelegateNavigationController , menuViewController: menuVC)
        APP_DELEGATE.drawerViewController?.menuSize = CGFloat(DemoSwiftConstants.menuSize)
        
        if  navigationCompleted {
            return
        }
        
        APP_DELEGATE.window?.rootViewController =  APP_DELEGATE.drawerViewController
        navigationCompleted = true
        APP_DELEGATE.drawerViewController?.statusBarStyle = .lightContent
//        APP_DELEGATE.firstCallSplash = false
        
    }
    
    // MARK: - Show Interstitial
    func showInterstitial() {
        if interstitialAdsFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            self.setUpNavigation()
            return
        }
        
        let iABTCF_TCString  = UserDefaults.standard.object(forKey: "IABTCF_TCString")
        if iABTCF_TCString == nil {
            NSLog("IABTCF_TCString not yet allowed")
            self.setUpNavigation()
            return
        }
        
        interstitialAdsFactory?.releaseMemory()
        
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory?.interstitialDelegate = self
        interstitialAdsFactory?.clickDelegate = self
        interstitialAdsFactory?.viewController = self
        interstitialAdsFactory?.placementId = "/\(MNG_ADS_APP_ID!)\(DemoSwiftConstants.PLACEMENTS.MNG_ADS_INTERSTITIAL_PLACEMENT_ID)"
        
        let preferenes = self.getTestPreferences()
        interstitialAdsFactory?.loadInterstitial(withPreferences: preferenes, autoDisplayed: false)
        NSLog("‼️MNGAdsSDKLog SplashViewController")
    }
    
    func getTestPreferences() ->MNGPreference {
        let preference = MNGPreference()
        preference.keyWord = "target=mngadsdemo;version=3.0.4;semantic=https://www.google.com"
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        preference.age = 60
        return preference
    }
    
    
    // MARK: - MNGads init delegate
    func mngAdsSDKFactoryDidFinishInitializing() {
        NSLog("MNGAds sucess initialization");
        let iABTCF_TCString  = UserDefaults.standard.object(forKey: "IABTCF_TCString")
        if iABTCF_TCString != nil {
            self.showInterstitial()
            APP_DELEGATE.firstCallSplash = true
        } else {
            self.setUpNavigation()
        }
    }

    func mngAdsSDKFactoryDidFailInitializationWithError(_ error:Error) {
        NSLog("MNGAds failed initialization");
        self.setUpNavigation()
    }
    
    // MARK: - MNGAdsAdapterInterstitialDelegate
    
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad")
        adsAdapter.displayInterstitial()
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear")
        self.setUpNavigation()
    }
    
    func adsAdapterInterstitialDidShown(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidShown");
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        NSLog("\(String(describing: error))")
        self.setUpNavigation()
    }
    
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("----->Inter1 clicked")
    }
    
    
    

}
