//
//  InterstitialManager.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 22/8/2022.
//

import Foundation
import BlueStackSDK

class InterstitialManager : NSObject , MNGAdsAdapterInterstitialDelegate , MNGClickDelegate  {
    
    //MARK: -Singleton
    static let _sharedManager = InterstitialManager()
    
    var interstitialAdsFactory: MNGAdsSDKFactory?
    
    private override init(){
        
    }
    
    //MARK: - Preferences
    func getTestPreferences() ->MNGPreference {
        let preference = MNGPreference()
        preference.keyWord = "target=mngadsdemo;version=3.0.4;semantic=https://www.google.com"
        preference.gender = MNGGender.male
        preference.setLocationPreferences(CLLocation.init(latitude: 48.87610, longitude: 10.453), withConsentFlag: 2)
        preference.contentUrl = "your content url"
        preference.age = 60
        return preference
    }
    
    //MARK: - Load Interstitials
    
    func showInterstitial(){
        
        if interstitialAdsFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            return
        }
        
        interstitialAdsFactory?.releaseMemory()
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory?.interstitialDelegate = self
        interstitialAdsFactory?.clickDelegate = self
        interstitialAdsFactory?.viewController = APP_DELEGATE.drawerViewController
        interstitialAdsFactory?.placementId = "/\(DemoSwiftConstants.appID)/interstitial"
        let preferences = self.getTestPreferences()
        interstitialAdsFactory?.loadInterstitial(withPreferences: preferences, autoDisplayed: false)
    }
    
    func showInterstitialOverlay(){
        
        if interstitialAdsFactory?.isBusy ?? false {
            NSLog("Ads Factory is busy")
            return
        }
        
        interstitialAdsFactory?.releaseMemory()
        interstitialAdsFactory = MNGAdsSDKFactory()
        interstitialAdsFactory?.interstitialDelegate = self
        interstitialAdsFactory?.clickDelegate = self
        interstitialAdsFactory?.viewController = APP_DELEGATE.drawerViewController
        interstitialAdsFactory?.placementId = "/\(DemoSwiftConstants.appID)/interstitialOverlay"
        let preferences = self.getTestPreferences()
        interstitialAdsFactory?.loadInterstitial(withPreferences: preferences)
    }
    
    //MARK: -interstitial Delegate
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidLoad");
        adsAdapter.showAd(fromRootViewController: APP_DELEGATE.drawerViewController, animated: false)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        NSLog("\(String(describing: error))")
    }
    
    func adsAdapterInterstitialDisappear(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDisappear");
    }
    
    func adsAdapterInterstitialDidShown(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterInterstitialDidShown");
    }
    
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("adsAdapterAdWasClicked");
    }
    
}
