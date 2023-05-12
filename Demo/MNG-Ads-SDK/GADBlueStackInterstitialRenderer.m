//
//  GADBlueStackInterstitialRenderer.m
//  MNG-Ads-SDK-Demo
//
//  Created by anypli on 8/3/2022.
//  Copyright © 2022 Bensalah Med Amine. All rights reserved.
//

#import "GADBlueStackInterstitialRenderer.h"
#import <BlueStackSDK/MNGAdsSDKFactory.h>
#include <stdatomic.h>
#import <BlueStackGADAdNetworkExtras.h>

@interface GADBlueStackInterstitialRenderer () <MNGAdsAdapterInterstitialDelegate,MNGClickDelegate,GADMediationInterstitialAd>
@property(nonatomic, strong)  MNGAdsSDKFactory * _interFactory;
@end

@implementation GADBlueStackInterstitialRenderer{
    // The completion handler to call when the ad loading succeeds or fails.
    GADMediationInterstitialLoadCompletionHandler _adLoadCompletionHandler;
    
    id<GADMediationInterstitialAdEventDelegate> _adEventDelegate;
    
    /// Indicates whether presentFromViewController: was called on this renderer.
    BOOL _presentCalled;
}

UIViewController* _viewController;



- (void)renderInterstitialForAdConfiguration:
(nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                           completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)
completionHandler{
    // Store the completion handler for later use.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler =
    [completionHandler copy];
    _adLoadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(
                                                                            _Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
                                                                                if (atomic_flag_test_and_set(&completionHandlerCalled)) {
                                                                                    return nil;
                                                                                }
                                                                                id<GADMediationInterstitialAdEventDelegate> delegate = nil;
                                                                                if (originalCompletionHandler) {
                                                                                    delegate = originalCompletionHandler(ad, error);
                                                                                }
                                                                                originalCompletionHandler = nil;
                                                                                return delegate;
                                                                            };
    
    if (self._interFactory.isBusy) {
        NSLog(@"[MAdvertise]:Ads Factory is busy");
        NSError *error = [[NSError alloc]initWithDomain:@"[MAdvertise]:Ads Factory is busy" code:1 userInfo:nil];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    if (_viewController == nil ) {
        NSLog(@"[MAdvertise]:Ads viewController is required ,use GADBlueStackMediationAdapter *adapter = [[GADBlueStackMediationAdapter alloc]init];[adapter setViewController:self]; ");
        NSError *error = [[NSError alloc]initWithDomain:@"[MAdvertise]:viewController is required " code:1 userInfo:nil];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    if (adConfiguration.credentials.settings.count != 0) {
        NSString *serverParameter =
        adConfiguration.credentials.settings[@"parameter"];
        NSString *appID = [self getAppIdByPlacementFromServerParameter:serverParameter];
        [MNGAdsSDKFactory initWithAppId:appID];
        self._interFactory = [[MNGAdsSDKFactory alloc]init];
        self._interFactory.interstitialDelegate = self;
        self._interFactory.placementId =  serverParameter ; //serverParameter ;
        self._interFactory.viewController = _viewController;
        self._interFactory.clickDelegate = self;
        MNGPreference *preferences = [[MNGPreference alloc]init];
        preferences.keyWord = [self createMngPreferenceKeyWord:adConfiguration.extras];
        [self._interFactory loadInterstitialWithPreferences:preferences autoDisplayed:NO];
        
    }else{
        NSLog(@"[MAdvertise]:adConfiguration.credential not found");
        NSError *error = [[NSError alloc]initWithDomain:@"[MAdvertise]:adConfiguration.credential not found" code:1 userInfo:nil];
        _adLoadCompletionHandler(nil, error);
        return;
    }
    
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
-(void)presentFromRootViewController:(UIViewController *)rootViewController{
    if (self._interFactory != nil) {
        self._interFactory.viewController = rootViewController;
        if([self._interFactory displayInterstitial]) {
        }
    }
}
#pragma mark -MNG Interstitial delegate
-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter {
    
    NSLog(@"[MAdvertise]: adsAdapterInterstitialDidLoad");
    _adEventDelegate = _adLoadCompletionHandler(self, nil);
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    if (_presentCalled) {
        NSLog(@"Received a MAdvertise SDK error during presentation: %@", error.localizedDescription);
        [_adEventDelegate didFailToPresentWithError:error];
        return;
    }
    _adLoadCompletionHandler(nil, error);
    NSLog(@"[MAdvertise]: adsAdapterInterstitialDidFailWithError");
    
}
-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _adEventDelegate;
    if (strongDelegate) {
        [strongDelegate willDismissFullScreenView];
    }
    NSLog(@"[MAdvertise]: adsAdapterInterstitialDisappear");
    
}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _adEventDelegate;
    if (strongDelegate) {
        [strongDelegate reportClick];
    }
    NSLog(@"[MAdvertise]: adsAdapterAdWasClicked");
    
}

-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    [_adEventDelegate reportImpression];
    
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

-(void)dealloc{
    if (__interFactory) {
        __interFactory = nil;
    }
}


#pragma mark GADMediationInterstitialAd

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    
    id<GADMediationInterstitialAdEventDelegate> strongDelegate = _adEventDelegate;
    _presentCalled = YES;
    
    if (self._interFactory != nil) {
        self._interFactory.viewController = viewController;
        if([self._interFactory displayInterstitial]) {
            
        }else{
            NSString *description = [NSString
                                     stringWithFormat:@"MAdvertiseinterFactory failed to present."];
            NSError *error = [[NSError alloc]initWithDomain:description code:2 userInfo:nil];
            [strongDelegate didFailToPresentWithError:error];
            return;
        }
    }else{
        NSString *description = [NSString
                                 stringWithFormat:@"MAdvertiseinterFactory failed to present."];
        NSError *error = [[NSError alloc]initWithDomain:description code:2 userInfo:nil];
        [strongDelegate didFailToPresentWithError:error];
        return;
    }
    
    [strongDelegate willPresentFullScreenView];
}
/**
 viewController that th ad will be shown
 @warning required in interstitial
 */
-(void)setViewController:(UIViewController*)viewController{
    viewController = viewController;
}

@end
