//
//  GADBlueStackBannerRenderer.m
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 8/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import "GADBlueStackBannerRenderer.h"
#include <stdatomic.h>
#import "BlueStackGADAdNetworkExtras.h"

@implementation GADBlueStackBannerRenderer{
    // The completion handler to call when the ad loading succeeds or fails.
    GADMediationBannerLoadCompletionHandler _adLoadCompletionHandler;
    
    // Ad Configuration for the ad to be rendered.
    GADMediationAdConfiguration *_adConfig;
    
    // An ad event delegate to invoke when ad rendering events occur.
    __weak id<GADMediationBannerAdEventDelegate> _adEventDelegate;
}
UIViewController* _viewController;




- (void)renderBannerForAdConfiguration:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
                     completionHandler:
(nonnull GADMediationBannerLoadCompletionHandler)completionHandler {
    
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler =
    [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
                                                                      _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
                                                                          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
                                                                              return nil;
                                                                          }
                                                                          id<GADMediationBannerAdEventDelegate> delegate = nil;
                                                                          if (originalCompletionHandler) {
                                                                              delegate = originalCompletionHandler(ad, error);
                                                                          }
                                                                          originalCompletionHandler = nil;
                                                                          return delegate;
                                                                      };
    if (adConfiguration.credentials.settings.count != 0) {
        NSString *serverParameter =
        adConfiguration.credentials.settings[@"parameter"];
        
        if (_bannerFactory.isBusy) {
            NSLog(@"[MAdvertise]: Ads Factory is busy");
            NSError *error = [[NSError alloc]initWithDomain:@"bannerFactory isBusy" code:1 userInfo:nil];
            _adLoadCompletionHandler(nil, error);
        }
        
        if (adConfiguration.topViewController == nil ) {
            NSError *error = [[NSError alloc]initWithDomain:@"topViewController not found" code:1 userInfo:nil];
            NSLog(@"[MAdvertise]: request BannerAd topViewController not found");
            _adLoadCompletionHandler(nil, error);

        }
        NSLog(@"[MAdvertise]: request BannerAd from Custom Class called");
        
        NSString *appID = [self getAppIdByPlacementFromServerParameter:serverParameter];
        [MNGAdsSDKFactory initWithAppId:appID];
        _bannerFactory = [[MNGAdsSDKFactory alloc]init];
        _bannerFactory.bannerDelegate = self;
        _bannerFactory.viewController = adConfiguration.topViewController;
        _bannerFactory.placementId = serverParameter;
        _bannerFactory.clickDelegate = self;
        MNGPreference *preferences = [[MNGPreference alloc]init];
        preferences.keyWord = [self createMngPreferenceKeyWord:adConfiguration.extras];
        MNGAdSize size  = [self getSize:adConfiguration.adSize ];
        [_bannerFactory loadBannerInFrame:size withPreferences:preferences];
        
    }else{
        NSLog(@"adConfiguration.credentials is not found");
        NSError *error = [[NSError alloc]initWithDomain:@"adConfiguration.credentials is not found" code:1 userInfo:nil];
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

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidLoad:(UIView *)adView preferredHeight:(CGFloat)preferredHeight {
    NSLog(@"[MAdvertise]: adsAdapter  bannerDidLoad");
    _adView = adView;
    _adEventDelegate = _adLoadCompletionHandler(self, nil);
    
}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidFailWithError:(NSError *)error{
    NSLog(@"[MAdvertise]: adsAdapter bannerDidFailWithError");
    _adLoadCompletionHandler(nil, error);
    
}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    
    id<GADMediationBannerAdEventDelegate> strongDelegate = _adEventDelegate;
    if (strongDelegate) {
        [strongDelegate reportClick];
    }
}

- (MNGAdSize)getSize:(GADAdSize)adSize {
    
    MNGAdSize size ;
    if (GADAdSizeEqualToSize(adSize,GADAdSizeBanner)) {
        BOOL isIPAD = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
        if (isIPAD) {
            size = kMNGAdSizeLeaderboard;
        } else {
            size = kMNGAdSizeBanner;
        }
        size = kMNGAdSizeBanner;
    } else if (GADAdSizeEqualToSize(adSize,GADAdSizeLargeBanner)) {
        size = kMNGAdSizeLargeBanner;
    }else {
        if (GADAdSizeEqualToSize(adSize,GADAdSizeMediumRectangle)) {
            size = kMNGAdSizeMediumRectangle;
        } else {
            if (GADAdSizeEqualToSize(adSize,GADAdSizeFullBanner)) {
                size = kMNGAdSizeFullBanner;
            }  else {
                if (GADAdSizeEqualToSize(adSize,GADAdSizeLeaderboard)) {
                    size = kMNGAdSizeLeaderboard;
                }  else {
                    BOOL isIPAD = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
                    size = (isIPAD)?kMNGAdSizeDynamicLeaderboard:kMNGAdSizeDynamicBanner;
                }
            }
        }
    }
    return size;
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
-(void)dealloc{
    if (_bannerFactory != nil) {
        _bannerFactory = nil;
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    return _adConfig.topViewController;
}
#pragma mark GADMediationBannerAd
- (UIView *)view {
    return _adView;
}

@end
