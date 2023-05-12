//
//  GADBlueStackRewardedRenderer.m
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 22/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import "GADBlueStackRewardedRenderer.h"
#import <BlueStackSDK/MNGAdsSDKFactory.h>
#include <stdatomic.h>
#import <BlueStackGADAdNetworkExtras.h>
#import <BlueStackSDK/MAdvertiseReward.h>
#import <BlueStackSDK/MAdvertiseRewardedVideoAd.h>

@interface GADBlueStackRewardedRenderer () <MAdvertiseAdapterRewardedVideoAdDelegate,MNGClickDelegate,GADMediationRewardedAd>

@end

@implementation GADBlueStackRewardedRenderer{
    // The completion handler to call when the ad loading succeeds or fails.
    GADMediationRewardedLoadCompletionHandler _adLoadCompletionHandler;

    // The BlueStack rewarded ad.
    MAdvertiseRewardedVideoAd * _videoAd;

    // An ad event delegate to invoke when ad rendering events occur.
    // Intentionally keeping a reference to the delegate because this delegate is returned from the
    // GMA SDK, not set on the GMA SDK.
    id<GADMediationRewardedAdEventDelegate> _adEventDelegate;

    /// Indicates whether presentFromViewController: was called on this renderer.
    BOOL _presentCalled;

}



- (void)loadRewardedAdForAdConfiguration:
            (nonnull GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
(nonnull GADMediationRewardedLoadCompletionHandler)completionHandler{
    
    
    // Store the ad config and completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
        _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
      if (atomic_flag_test_and_set(&completionHandlerCalled)) {
        return nil;
      }
      id<GADMediationRewardedAdEventDelegate> delegate = nil;
      if (originalCompletionHandler) {
        delegate = originalCompletionHandler(ad, error);
      }
      originalCompletionHandler = nil;
      return delegate;
    };
    
  
    if (adConfiguration.credentials.settings.count != 0) {
        NSString *serverParameter =
        adConfiguration.credentials.settings[@"parameter"];
        NSString *appID = [self getAppIdByPlacementFromServerParameter:serverParameter];
        [MNGAdsSDKFactory initWithAppId:appID];
        _videoAd = [[MAdvertiseRewardedVideoAd alloc]initWithPlacementID:serverParameter];
        [_videoAd setDelegate:self];
        [_videoAd loadAd];
        
    }else{
        NSLog(@"[MAdvertise]:adConfiguration.credential not found");
        NSError *error = [[NSError alloc]initWithDomain:@"[MAdvertise]:adConfiguration.credential not found" code:1 userInfo:nil];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    

    
}

- (NSString * )getAppIdByPlacementFromServerParameter:(NSString  *)serverParameter {
    NSString * appID;
    if (serverParameter != nil) {
        NSArray *items = [serverParameter componentsSeparatedByString:@"/"];
        if (items.count >= 2) {
            appID  =[items objectAtIndex:1];
        }
    }
    return appID;
}
-(NSString*)createMngPreferenceKeyWord:(BlueStackGADAdNetworkExtras *)request{
    NSString* keyWord = @"";
    NSString* userRequest = @"";
    NSString*  requestExtrasString = @"";
    if (![request.keywords isEqualToString:@""]) {
        userRequest = [request.keywords stringByAppendingString:@";"];
    }
    if (request.customTargetingBlueStack != nil) {
        requestExtrasString = [NSString stringWithFormat:@"%@", request.customTargetingBlueStack];
        requestExtrasString = [requestExtrasString stringByReplacingOccurrencesOfString:@"{"withString:@""];
        requestExtrasString = [requestExtrasString stringByReplacingOccurrencesOfString:@"}"withString:@""];
        requestExtrasString = [requestExtrasString stringByReplacingOccurrencesOfString:@"\n"withString:@""];
        requestExtrasString = [requestExtrasString stringByReplacingOccurrencesOfString:@" "withString:@""];
        NSString *lastChar = [requestExtrasString substringFromIndex:[requestExtrasString length] - 1];
        if ([lastChar isEqualToString:@";"]){
            requestExtrasString = [requestExtrasString substringToIndex:[requestExtrasString length] - 1];
        }
    }
    keyWord = [userRequest stringByAppendingString:requestExtrasString];
    return keyWord;
}
-(void)setViewController:(UIViewController*)viewController{
    
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _adEventDelegate;
    _presentCalled = YES;
    
    if (!_videoAd.isAdValid) {
        
      NSString *description = [NSString
          stringWithFormat:@"MAdvertiseRewardedVideoAd failed to present."];
        NSError *error = [[NSError alloc]initWithDomain:description code:1 userInfo:nil];
      [strongDelegate didFailToPresentWithError:error];
      return;
    }else{
        [_videoAd showAdFromRootViewController:viewController animated:true];
    }
    [strongDelegate willPresentFullScreenView];
    [strongDelegate didStartVideo];
}
- (void)adsAdapterRewardedVideoAdDidLoad:(MNGAdsAdapter *)adsAdapter {
    _adEventDelegate = _adLoadCompletionHandler(self, nil);

}

- (void)adsAdapter:(MNGAdsAdapter *)adsAdapter rewardedVideoAdDidFailWithError:(NSError *)error {
    if (_presentCalled) {
      NSLog(@"Received a BlueStack SDK error during presentation: %@", error.localizedDescription);
      [_adEventDelegate didFailToPresentWithError:error];
      return;
    }
    _adLoadCompletionHandler(nil, error);
}

- (void)adsAdapterRewardedVideoAdDidClose:(MNGAdsAdapter *)adsAdapter {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _adEventDelegate;
    if (strongDelegate) {
      [strongDelegate didDismissFullScreenView];
    }
}

- (void)adsAdapterRewardedVideoAdDidClick:(MNGAdsAdapter *)adsAdapter {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _adEventDelegate;
    if (strongDelegate) {
      [strongDelegate reportClick];
    }
}

- (void)adsAdapterRewardedVideoAdComplete:(MNGAdsAdapter *)adsAdapter withReward:(MAdvertiseReward *)reward {
    NSString *message = @"Video rewarded";
    if (reward) {
        message = [NSString stringWithFormat:@"%@ /n type: %@ /n  amount: %@ /n",message,reward.type, reward.amount];
        id<GADMediationRewardedAdEventDelegate> strongDelegate = _adEventDelegate;
        if (strongDelegate) {
            NSDecimalNumber *decRewardAmount = [NSDecimalNumber decimalNumberWithDecimal:[reward.amount decimalValue]];

          GADAdReward *rewardDfp = [[GADAdReward alloc] initWithRewardType:reward.type
                                                           rewardAmount:decRewardAmount];
          [strongDelegate didEndVideo];
          [strongDelegate didRewardUserWithReward:rewardDfp];
        }
    }

}

- (void)adsAdapterRewardedVideoAdWillLogImpression:(MNGAdsAdapter *)adsAdapter {
    [_adEventDelegate reportImpression];

}

@end
