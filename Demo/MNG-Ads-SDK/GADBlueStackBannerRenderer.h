//
//  GADBlueStackBannerRenderer.h
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 8/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface GADBlueStackBannerRenderer : NSObject<GADMediationBannerAd,MNGAdsAdapterBannerDelegate,MNGClickDelegate>
@property(nonatomic, strong)  MNGAdsSDKFactory * _Nonnull bannerFactory;
@property (nonatomic, readonly, nonnull) UIView *adView;
- (void)renderBannerForAdConfiguration:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
                     completionHandler:(nonnull GADMediationBannerLoadCompletionHandler)completionHandler ;


@end

