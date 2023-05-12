//
//  GADBlueStackNativeAdRenderer.m
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 9/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import "GADBlueStackNativeAdRenderer.h"
#include <stdatomic.h>
#import <BlueStackSDK/MNGAdsSDKFactory.h>
#import <BlueStackSDK/MNGNAtiveObject.h>
#import "BlueStackGADAdNetworkExtras.h"

@interface GADBlueStackNativeAdRenderer () <MNGAdsAdapterNativeDelegate,MNGClickDelegate,GADMediationNativeAd>{
    /// Native ad view options.
    GADNativeAdViewAdOptions *_nativeAdViewAdOptions;
    MNGAdsSDKFactory * _nativeFactory;
    
    /// UIView media view.
    UIView *_mediaView;
    UIImageView *_iconImageView;
    UIView * _nativeView;
    UIButton* _callToActionLabel;
    MNGNAtiveObject *_nativeObject;
}
@end
@implementation GADBlueStackNativeAdRenderer{
    // The completion handler to call when the ad loading succeeds or fails.
    GADMediationNativeLoadCompletionHandler _adLoadCompletionHandler;
    
    
    // An ad event delegate to invoke when ad rendering events occur.
    __weak id<GADMediationNativeAdEventDelegate> _adEventDelegate;
    
    ///  A dictionary of asset names and object pairs for assets that are not handled by properties of
    ///  the GADMediatedUnifiedNativeAd subclass
    NSDictionary *_extraAssets;
    
    
    
    /// Holds the state for impression being logged.
    atomic_flag _impressionLogged;
    
    
    
    
}
UIViewController* _viewController;


- (void)renderNativeAdForAdConfiguration:
(nonnull GADMediationNativeAdConfiguration *)adConfiguration
                       completionHandler:(nonnull GADMediationNativeLoadCompletionHandler)
completionHandler{
    
    // Store the ad config and completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationNativeLoadCompletionHandler originalCompletionHandler =
    [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(
                                                                      _Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {
                                                                          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
                                                                              return nil;
                                                                          }
                                                                          id<GADMediationNativeAdEventDelegate> delegate = nil;
                                                                          if (originalCompletionHandler) {
                                                                              delegate = originalCompletionHandler(ad, error);
                                                                          }
                                                                          originalCompletionHandler = nil;
                                                                          return delegate;
                                                                      };
    
    
    //    BOOL requestedUnified = [adTypes containsObject:GADAdLoaderAdTypeNative];
    BOOL requestedUnified = YES;
    
    // This custom event assumes you have implemented unified native advanced in your app as is done
    // in this sample.
    
    if (!requestedUnified) {
        NSString *description = @"You must request the unified native ad format.";
        NSDictionary *userInfo =
        @{NSLocalizedDescriptionKey : description, NSLocalizedFailureReasonErrorKey : description};
        NSError *error =
        [NSError errorWithDomain:@"BlueStack" code:0 userInfo:userInfo];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    
    // This custom event uses the server parameter to carry an ad unit ID, which is the most common
    // use case.
    if (_nativeFactory != nil) {
        [_nativeFactory releaseMemory];
        _nativeFactory = nil;
        
    }
    if (adConfiguration.credentials.settings.count == 0) {
        NSString *description = @"You adConfiguration.credentials not found";
        NSDictionary *userInfo =
        @{NSLocalizedDescriptionKey : description, NSLocalizedFailureReasonErrorKey : description};
        NSError *error =
        [NSError errorWithDomain:@"BlueStack" code:0 userInfo:userInfo];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    if (_viewController == nil ) {
        NSLog(@"[MAdvertise]:Ads viewController is required ,use GADBlueStackMediationAdapter *adapter = [[GADBlueStackMediationAdapter alloc]init];[adapter setViewController:self]; ");
        NSError *error = [[NSError alloc]initWithDomain:@"[MAdvertise]:viewController is required " code:1 userInfo:nil];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    NSString *serverParameter =
    adConfiguration.credentials.settings[@"parameter"];
    NSString *appID = [self getAppIdByPlacementFromServerParameter:serverParameter];
    [MNGAdsSDKFactory initWithAppId:appID];
    _nativeFactory = [[MNGAdsSDKFactory alloc]init];
    _nativeFactory.nativeDelegate = self;
    _nativeFactory.viewController = _viewController;
    _nativeFactory.placementId =  serverParameter ; //_nativePlacement;
    _nativeFactory.clickDelegate = self;
    
    MNGPreference *preferences = [[MNGPreference alloc]init];
    preferences.keyWord = [self createMngPreferenceKeyWord:adConfiguration.extras];
    
    [_nativeFactory loadNativeWithPreferences:preferences withCover:YES];
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
#pragma mark - NativeAdMNG  protocol methods

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidLoad:(MNGNAtiveObject *)adView{
    
    _nativeObject = adView;
    _mediaView= [[UIView alloc] init];
    
    _iconImageView= [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    _callToActionLabel = [[UIButton alloc] init];
    _nativeView= [[UIView alloc] init];
    
    _adEventDelegate = _adLoadCompletionHandler(self, nil);
    
}


- (void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidFailWithError:(NSError *)error withCover:(BOOL)cover{
    
    _adLoadCompletionHandler(nil, error);
    
}

- (void)dealloc{
    if (_nativeFactory) {
        _nativeFactory = nil;
    }
}

/**
 viewController that th ad will be shown
 @warning required in interstitial
 */
-(void)setViewController:(UIViewController*)viewController{
    _viewController = viewController;
}
- (BOOL)hasVideoContent {
    return YES;
}
- (nullable NSString *)advertiser {
    return  nil;
}

- (nullable NSString *)body {
    return _nativeObject.body;
}

- (nullable NSArray<GADNativeAdImage *> *)images {
    
    return nil;
}

- (nullable UIView *)mediaView {
    return _mediaView;
}

- (nullable UIView *)adChoicesView {
    return _nativeObject.badgeView;
}

- (nullable GADNativeAdImage *)icon {
    return [[GADNativeAdImage alloc] initWithImage:_iconImageView.image];
}

- (nullable NSDictionary<NSString *, id> *)extraAssets {
    NSString *socialContext = [_nativeObject.socialContext copy];
    if (socialContext) {
        return @{@"socialContext" : socialContext};
    }
    return nil;
}

- (nullable NSString *)headline {
    return _nativeObject.title;
}

- (nullable NSString *)price {
    return _nativeObject.localizedPrice;
}

- (nullable NSDecimalNumber *)starRating {
    return nil;
}

- (nullable NSString *)store {
    return _nativeObject.socialContext;
}
- (nullable NSString *)callToAction {
    return _nativeObject.callToAction;
}


- (void)didRenderInView:(UIView *)view
    clickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
 nonclickableAssetViews:
(NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
         viewController:(UIViewController *)viewController {
    
    UIImageView *iconView = nil;
    if ([clickableAssetViews[GADNativeIconAsset] isKindOfClass:[UIImageView class]]) {
        iconView = (UIImageView *)clickableAssetViews[GADNativeIconAsset];
    }
    
    GADMediaView *nativeAd = nil;
    if ([clickableAssetViews[GADNativeMediaViewAsset] isKindOfClass:[GADMediaView class]]) {
        nativeAd = (GADMediaView *)clickableAssetViews[GADNativeMediaViewAsset];
    }
    
    UIButton *callToActionButton = nil;
    if ([clickableAssetViews[GADNativeCallToActionAsset] isKindOfClass:[UIButton class]]) {
        callToActionButton = (UIButton *)clickableAssetViews[GADNativeCallToActionAsset];
    }
  
    [_nativeObject registerViewForInteraction:nativeAd withMediaView: _mediaView withIconImageView:iconView withViewController: viewController withClickableView:callToActionButton];
    
    
}
- (void)didUntrackView:(nullable UIView *)view{
    
    
}
@end
