//
//  GADBlueStackInterstitialRenderer.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import Foundation
import GoogleMobileAds
import BlueStackSDK


class GADBlueStackInterstitialRenderer : NSObject , GADMediationInterstitialAd ,MNGAdsAdapterInterstitialDelegate , MNGClickDelegate {
 
    
    var interFactory : MNGAdsSDKFactory?
    var viewController : UIViewController?
    var adLoadCompletionHandler : GADMediationInterstitialLoadCompletionHandler?
    
    
    override init(){
        super.init()
    }
    
    //MARK: create Preferences keyword
    func createMngPreferenceKeyWord(request : BlueStackGADAdNetworkExtras) -> String {
        let keyword = "test"
//        var userRequest = ""
//        var requestExtrasString = ""
        
//        if request.keywords != "" {
//            userRequest = request.keywords.append(";")
//        }
        
        
//        if request.customTargetingBlueStack != nil {
//            requestExtrasString = request.customTargetingBlueStack
//        }
        
        return keyword
    }

    //MARK: GET THE APP ID From server Parameters
    func getAppIdByPlacementFromServerParameter(serverParameter : String) -> String {
        var appId : String = ""
        let items = serverParameter.components(separatedBy: "/")
        if items.count >= 2 {
            appId = items[1]
        }
        return appId
    }
    
    
    func renderInterstitialForAdConfiguration(adConfiguration : GADMediationInterstitialAdConfiguration, completionHandler : @escaping GADMediationInterstitialLoadCompletionHandler){

        adLoadCompletionHandler  = completionHandler
        
        if adConfiguration.credentials.settings.count != 0 {
            let serverParamter = adConfiguration.credentials.settings["parameter"]
            
            if interFactory?.isBusy ?? false {
                NSLog("[MAdvertise]: Ads Factory is busy")
                let error : NSError = NSError(domain: "bannerFactory isBusy", code: 1, userInfo: nil)
                _ = adLoadCompletionHandler!(nil, error)
                return
            }
            
            if self.viewController == nil {
                NSLog("no view controller")
                let error : NSError = NSError(domain: "topViewController not found", code: 1, userInfo: nil)
                _ = adLoadCompletionHandler!(nil, error)
                return
            }
            
            NSLog("[MAdvertise]: request BannerAd from Custom Class called");
            
            let appId = self.getAppIdByPlacementFromServerParameter(serverParameter: serverParamter as! String)
            MNGAdsSDKFactory.initWithAppId(appId)
            interFactory = MNGAdsSDKFactory()
            interFactory?.interstitialDelegate  = self
            interFactory?.viewController = self.viewController
            interFactory?.placementId = serverParamter as? String
            interFactory?.clickDelegate = self
            let preferences = MNGPreference()
            preferences.keyWord = self.createMngPreferenceKeyWord(request: adConfiguration.extras as! BlueStackGADAdNetworkExtras)
            interFactory?.loadInterstitial(withPreferences: preferences, autoDisplayed: false)
            
        }else {
            NSLog("adConfiguration.credentials is not found");
            let error : NSError = NSError(domain: "adConfiguration.credentials is not found", code: 1, userInfo: nil)
            _ = completionHandler(nil, error)
            return
        }
    }
    
    //MARK: Interstitial Delegate
    func adsAdapterInterstitialDidLoad(_ adsAdapter: MNGAdsAdapter!) {
        NSLog("[MAdvertise]: adsAdapterInterstitialDidLoad");
        _ = adLoadCompletionHandler!(self, nil);
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, interstitialDidFailWithError error: Error!) {
        _ = adLoadCompletionHandler!(nil, error);
        NSLog("[MAdvertise]: adsAdapterInterstitialDidFailWithError")
    }
    
    //MARK: GADMediationInterstitialAd
    func present(from viewController: UIViewController) {
        if interFactory != nil {
            self.interFactory?.viewController = viewController
            if interFactory!.displayInterstitial() {
                
            } else {
                let error : NSError = NSError(domain: "MAdvertiseinterFactory failed to present.", code: 2, userInfo: nil)
                _ = adLoadCompletionHandler!(nil, error);
            }
        }
    }
    
}
