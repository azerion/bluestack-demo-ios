//
//  GADBlueStackInterstitialRenderer.h
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 8/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface GADBlueStackInterstitialRenderer : NSObject
/// Asks the receiver to render the ad configuration.
- (void)renderInterstitialForAdConfiguration:
            (nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                           completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)
                                                 completionHandler;
-(void)setViewController:(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
