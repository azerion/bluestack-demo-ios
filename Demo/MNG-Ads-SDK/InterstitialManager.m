//
//  InterstitialManager.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/23/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "InterstitialManager.h"

static InterstitialManager * _sharedManager;

@implementation InterstitialManager{
    MNGAdsSDKFactory *interstitialAdsFactory;
}

+(InterstitialManager*)sharedManager{
    if (!_sharedManager) {
        _sharedManager = [[InterstitialManager alloc]init];
    }
    return _sharedManager;
}

-(void)showInterstitial{
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"IABTCF_TCString"] == nil) {
        NSLog(@"IABTCF_TCString not yet allowed");
        return;
    }
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_PLACEMENT_ID;
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
    MNGPreference *preferences = [Utils getTestPreferences] ;
    [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:NO];
}

-(void)showInterstitialOverlay{
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"IABTCF_TCString"] == nil) {
        NSLog(@"IABTCF_TCString not yet allowed");
        return;
    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID;
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
    MNGPreference *preferences = [Utils getTestPreferences] ;
    [interstitialAdsFactory loadInterstitialWithPreferences:preferences];
}

#pragma mark - MNGAdsAdapterInterstitialDelegate

-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidLoad");
    [adsAdapter showAdFromRootViewController:[APP_DELEGATE drawerViewController] animated:NO] ;
}

-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDisappear");
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    
}
-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidShown");

}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterAdWasClicked");
}

@end
