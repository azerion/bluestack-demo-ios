//
//  GADBlueStackRewardedRenderer.h
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 22/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface GADBlueStackRewardedRenderer : NSObject
/// Asks the receiver to render the ad configuration.
- (void)loadRewardedAdForAdConfiguration:
            (nonnull GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (nonnull GADMediationRewardedLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
