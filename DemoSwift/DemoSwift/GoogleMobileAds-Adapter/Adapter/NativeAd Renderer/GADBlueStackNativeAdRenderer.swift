//
//  GADBlueStackNativeAdRenderer.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import Foundation
import GoogleMobileAds
import BlueStackSDK


class GADBlueStackNativeAdRenderer : NSObject , GADMediationNativeAd ,MNGAdsAdapterNativeDelegate , MNGClickDelegate {
    
    var headline: String?
    
    var images: [GADNativeAdImage]?
    
    var body: String?
    
    var icon: GADNativeAdImage?
    
    var callToAction: String?
    
    var starRating: NSDecimalNumber?
    
    var store: String?
    
    var price: String?
    
    var advertiser: String?
    
    var extraAssets: [String : Any]?
    
    
    
    var nativeObject: MNGNAtiveObject? = nil
    var nativeFactory : MNGAdsSDKFactory?
    var viewController : UIViewController?
    var adLoadCompletionHandler : GADMediationNativeLoadCompletionHandler?
    
    
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
    
    
    func renderNativeAdForAdConfiguration(adConfiguration : GADMediationNativeAdConfiguration, completionHandler : @escaping GADMediationNativeLoadCompletionHandler){

        adLoadCompletionHandler  = completionHandler
        
        if adConfiguration.credentials.settings.count != 0 {
            let serverParamter = adConfiguration.credentials.settings["parameter"]
            
            if nativeFactory?.isBusy ?? false {
                NSLog("[MAdvertise]: Ads Factory is busy")
                let error : NSError = NSError(domain: "bannerFactory isBusy", code: 1, userInfo: nil)
                adLoadCompletionHandler!(nil, error)
                return
            }
            
            if self.viewController == nil {
                NSLog("no view controller")
                let error : NSError = NSError(domain: "topViewController not found", code: 1, userInfo: nil)
                adLoadCompletionHandler!(nil, error)
                return
            }
            
            NSLog("[MAdvertise]: request BannerAd from Custom Class called");
            
            let appId = self.getAppIdByPlacementFromServerParameter(serverParameter: serverParamter as! String)
            MNGAdsSDKFactory.initWithAppId(appId)
            nativeFactory = MNGAdsSDKFactory()
            nativeFactory?.nativeDelegate  = self
            nativeFactory?.viewController = self.viewController
            nativeFactory?.placementId = serverParamter as? String
            nativeFactory?.clickDelegate = self
            let preferences = MNGPreference()
            preferences.keyWord = self.createMngPreferenceKeyWord(request: adConfiguration.extras as! BlueStackGADAdNetworkExtras)
            nativeFactory?.loadNative(withPreferences: preferences,withCover: true)
            
        }else {
            NSLog("adConfiguration.credentials is not found");
            let error : NSError = NSError(domain: "adConfiguration.credentials is not found", code: 1, userInfo: nil)
            _ = completionHandler(nil, error)
            return
        }
    }
    
    //MARK: NativeAd Delegate
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidLoad adView: MNGNAtiveObject!) {
        nativeObject = adView
        
        body = nativeObject?.body
        extraAssets = ["socialContext" : nativeObject?.socialContext ?? ""]
        headline = nativeObject?.title
        price = nativeObject?.localizedPrice
        store = nativeObject?.socialContext
        callToAction = nativeObject?.callToAction
        
        
        adLoadCompletionHandler!(self, nil);
    }
    
    func adsAdapter(_ adsAdapter: MNGAdsAdapter!, nativeObjectDidFailWithError error: Error!, withCover cover: Bool) {
        adLoadCompletionHandler!(nil,error)
    }
    
   
}
