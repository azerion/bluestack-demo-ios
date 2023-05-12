//
//  GADBlueStackNativeAdRenderer.h
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 9/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface GADBlueStackNativeAdRenderer : NSObject
/// Asks the receiver to render the ad configuration.
- (void)renderNativeAdForAdConfiguration:
            (nonnull GADMediationNativeAdConfiguration *)adConfiguration
                           completionHandler:(nonnull GADMediationNativeLoadCompletionHandler)
                                                 completionHandler;
-(void)setViewController:(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
