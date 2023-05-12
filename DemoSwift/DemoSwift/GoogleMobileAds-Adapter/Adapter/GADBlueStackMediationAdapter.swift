//
//  GADBlueStackMediationAdapter.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 18/8/2022.
//

import Foundation
import GoogleMobileAds
import UIKit

//the class name must be  appName.className (BlueStackDemoDev.GADBlueStackMediationAdapter)
//See this https://developers.google.com/ad-manager/mobile-ads-sdk/ios/custom-events/interstitial //className section
class GADBlueStackMediationAdapter : NSObject {
    
    let viewController : UIViewController
    let _banner  : GADBlueStackBannerRenderer = GADBlueStackBannerRenderer()
    let _interstitial  : GADBlueStackInterstitialRenderer = GADBlueStackInterstitialRenderer()
    let _native : GADBlueStackNativeAdRenderer = GADBlueStackNativeAdRenderer()
    
    init(viewController : UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    
    //Version
    //MARK: load banner
    func loadBannerForAdConfiguration(adConfiguration : GADMediationBannerAdConfiguration, completionHandler : @escaping GADMediationBannerLoadCompletionHandler) {
        
        _banner.renderBannerForAdConfiguration(adConfiguration: adConfiguration, completionHandler: completionHandler)
        
    }
    
    //MARK: load Interstitial
    func loadInterstitialForAdConfiguration(adConfiguration : GADMediationInterstitialAdConfiguration, completionHandler : @escaping GADMediationInterstitialLoadCompletionHandler) {
        
        _interstitial.viewController = viewController
        _interstitial.renderInterstitialForAdConfiguration(adConfiguration: adConfiguration, completionHandler: completionHandler)

    }
    
    //MARK: load NativeAd
    func loadNativeAdForAdConfiguration(adConfiguration : GADMediationNativeAdConfiguration, completionHandler : @escaping GADMediationNativeLoadCompletionHandler) {
        
        _native.viewController = viewController
        _native.renderNativeAdForAdConfiguration(adConfiguration: adConfiguration, completionHandler: completionHandler)

    }
    
    
    
}
