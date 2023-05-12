//
//  GADBlueStackMediationAdapter.m
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 8/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import "GADBlueStackMediationAdapter.h"
#import "GADBlueStackBannerRenderer.h"
#import "GADBlueStackInterstitialRenderer.h"
#import "GADBlueStackNativeAdRenderer.h"
#import "GADBlueStackRewardedRenderer.h"

#import "BlueStackGADAdNetworkExtras.h"

@interface GADBlueStackMediationAdapter () <GADMediationAdapter>

@end

@implementation GADBlueStackMediationAdapter{
  
    /// Bluestack  Network interstitial ad wrapper.
    GADBlueStackInterstitialRenderer *_interstitial;
    /// Bluestack  Network banner ad wrapper.
    GADBlueStackBannerRenderer *_banner;
    /// Bluestack  Network banner ad wrapper.
    GADBlueStackNativeAdRenderer *_native;
    /// BluestackNetwork rewarded ad wrapper.
    GADBlueStackRewardedRenderer *_rewardedAd;
}
UIViewController* _viewController;

-(id)init {
    self = [super init];
    return self;
}

+ (GADVersionNumber)adSDKVersion {
    GADVersionNumber version = {0};
      NSArray<NSString *> *components = [@"4.0.0" componentsSeparatedByString:@"."];
      if (components.count == 4) {
        version.majorVersion = components[0].integerValue;
        version.minorVersion = components[1].integerValue;
        version.patchVersion = components[2].integerValue * 100 + components[3].integerValue;
      }
      return version;
    
}


+ (GADVersionNumber)adapterVersion {
    GADVersionNumber version = {0};
      NSArray<NSString *> *components = [@"4.0.0" componentsSeparatedByString:@"."];
      if (components.count == 4) {
        version.majorVersion = components[0].integerValue;
        version.minorVersion = components[1].integerValue;
        version.patchVersion = components[2].integerValue * 100 + components[3].integerValue;
      }
      return version;
}


+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [BlueStackGADAdNetworkExtras class];
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    
    
    _banner = [[GADBlueStackBannerRenderer alloc] init];
    [_banner renderBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialForAdConfiguration:
(GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:
(GADMediationInterstitialLoadCompletionHandler)completionHandler {

      _interstitial = [[GADBlueStackInterstitialRenderer alloc] init];
      [_interstitial setViewController:_viewController];
      [_interstitial renderInterstitialForAdConfiguration:adConfiguration
                                        completionHandler:completionHandler];
}


- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
   
      _native = [[GADBlueStackNativeAdRenderer alloc] init];
      [_native setViewController:_viewController];
      [_native renderNativeAdForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler {

    _rewardedAd = [[GADBlueStackRewardedRenderer alloc] init];
    [_rewardedAd loadRewardedAdForAdConfiguration:adConfiguration
                                completionHandler:completionHandler];
    
}

/**
 viewController that th ad will be shown
@warning required in interstitial
*/
+(void)setViewController:(UIViewController*)viewController{
    _viewController = viewController;
}

@end
