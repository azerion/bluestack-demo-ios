//
//  GADBlueStackBannerRenderer.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import Foundation
import GoogleMobileAds
import BlueStackSDK


class GADBlueStackBannerRenderer : NSObject , GADMediationBannerAd ,MNGAdsAdapterBannerDelegate , MNGClickDelegate {
    
    var view = UIView()
    var bannerFactory : MNGAdsSDKFactory?
    var adLoadCompletionHandler : GADMediationBannerLoadCompletionHandler?
    
//    var _adLoadCompletionHandler : GADMediationBannerLoadCompletionHandler?
    
    
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
    
    //MARK: -getSize
    func getSize(adSize : GADAdSize) -> MNGAdSize {
        var size : MNGAdSize = MNGAdSize()
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        
        if GADAdSizeEqualToSize(adSize, GADAdSizeBanner) {
            size = isIpad ? kMNGAdSizeLeaderboard : kMNGAdSizeBanner
        } else if  GADAdSizeEqualToSize(adSize, GADAdSizeLargeBanner) {
            size = kMNGAdSizeLargeBanner
        } else {
            if (GADAdSizeEqualToSize(adSize,GADAdSizeMediumRectangle)) {
                size = kMNGAdSizeMediumRectangle;
            } else {
                if (GADAdSizeEqualToSize(adSize,GADAdSizeFullBanner)) {
                    size = kMNGAdSizeFullBanner;
                }  else {
                    if (GADAdSizeEqualToSize(adSize,GADAdSizeLeaderboard)) {
                        size = kMNGAdSizeLeaderboard;
                    }  else {
                        size = isIpad ? kMNGAdSizeDynamicLeaderboard:kMNGAdSizeDynamicBanner;
                    }
                }
            }
        }
        
        return size
    }
    
    
    func renderBannerForAdConfiguration(adConfiguration : GADMediationBannerAdConfiguration, completionHandler : @escaping GADMediationBannerLoadCompletionHandler){

        adLoadCompletionHandler  = completionHandler
        
        if adConfiguration.credentials.settings.count != 0 {
            let serverParamter = adConfiguration.credentials.settings["parameter"]
            
            if bannerFactory?.isBusy ?? false {
                NSLog("[MAdvertise]: Ads Factory is busy")
                let error : NSError = NSError(domain: "bannerFactory isBusy", code: 1, userInfo: nil)
                _ = adLoadCompletionHandler!(nil, error)
                return
            }
            
            if adConfiguration.topViewController == nil {
                NSLog("no view controller")
                let error : NSError = NSError(domain: "topViewController not found", code: 1, userInfo: nil)
                _ = adLoadCompletionHandler!(nil, error)
                return
            }
            
            NSLog("[MAdvertise]: request BannerAd from Custom Class called");
            
            let appId = self.getAppIdByPlacementFromServerParameter(serverParameter: serverParamter as! String)
            MNGAdsSDKFactory.initWithAppId(appId)
            bannerFactory = MNGAdsSDKFactory()
            bannerFactory?.bannerDelegate  = self
            bannerFactory?.viewController = adConfiguration.topViewController
            bannerFactory?.placementId = serverParamter as? String
            bannerFactory?.clickDelegate = self
            let preferences = MNGPreference()
            preferences.keyWord = self.createMngPreferenceKeyWord(request: adConfiguration.extras as! BlueStackGADAdNetworkExtras)
            let size = self.getSize(adSize: adConfiguration.adSize)
            bannerFactory?.loadBanner(inFrame: size, withPreferences: preferences)
            
        }else {
            NSLog("adConfiguration.credentials is not found");
            let error : NSError = NSError(domain: "adConfiguration.credentials is not found", code: 1, userInfo: nil)
            _ = completionHandler(nil, error)
            return
        }
    }
    
    //MARK: bANNER Delegate
    func adsAdapterAdWasClicked(_ adsAdapter: MNGAdsAdapter!) {
        
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidLoad adView: UIView!, preferredHeight: CGFloat) {
        NSLog("[MAdvertise]: adsAdapter  bannerDidLoad");
        view = adView
        //completion
        _ = adLoadCompletionHandler!(view as? GADMediationBannerAd,nil)
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, bannerDidFailWithError error: Error!) {
        NSLog("[MAdvertise]: adsAdapter bannerDidFailWithError");
        _ = adLoadCompletionHandler!(nil, error)
    }
    
}
