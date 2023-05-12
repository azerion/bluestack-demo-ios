//
//  SplashViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 15/02/2018.
//  Copyright © 2018 MAdvertise. All rights reserved.
//

#import "SplashViewController.h"
#import "BannerViewController.h"
#import "MenuViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController{
    MNGAdsSDKFactory *interstitialAdsFactory;
}

-(void)viewDidLoad{
    

    [MNGAdsSDKFactory setDebugModeEnabled:DEBUG_MODE_ENABLED];
    [MNGAdsSDKFactory setDelegate:self];
    [MNGAdsSDKFactory initWithAppId:MNG_ADS_APP_ID];

//    APP_DELEGATE.firstCallSplash = YES;

    NSLog(@"%@ , %d",MNG_ADS_APP_ID,DEBUG_MODE_ENABLED);
}
-(void)viewDidAppear:(BOOL)animated {
    
    
//    APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;

}
- (void)viewDidDisappear:(BOOL)animated{
//    APP_DELEGATE.firstCallSplash = NO;
}
-(void)showInterstitial{
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        [self setupNavigation];

    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"IABTCF_TCString"] == nil) {
        NSLog(@"IABTCF_TCString not yet allowed");
        [self setupNavigation];

    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.clickDelegate = self;

    interstitialAdsFactory.viewController = self;
    interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_PLACEMENT_ID;
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
     MNGPreference *preferences = [Utils getTestPreferences] ;
    [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:NO];
    NSLog(@"‼️MNGAdsSDKLog SplashViewController");

}



-(void)MNGAdsSDKFactoryDidFinishInitializing{
    NSLog(@"MNGAds sucess initialization");
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"IABTCF_TCString"] != nil) {
        [self showInterstitial];
        APP_DELEGATE.firstCallSplash = YES;
    }else{
        [self setupNavigation];

    }

}


-(void)MNGAdsSDKFactoryDidFinishAdaptersInitializing:(BlueStackInitializationStatus *)blueStackInitializationStatus{
    for (BlueStackAdapterStatus* blueStackAdapterStatus in blueStackInitializationStatus.adaptersStatus) {
        NSString* message = [NSString  stringWithFormat:@"adapter name %@ has this status %u with description %@ ", blueStackAdapterStatus.provider , blueStackAdapterStatus.state, blueStackAdapterStatus.descriptionStatus] ;
        NSLog(@"%@", message);
    }
}

-(void)MNGAdsSDKFactoryDidFailInitializationWithError:(NSError *)error {
    NSLog(@"MNGAds failed initialization");
    [self setupNavigation];

}

#pragma mark - MNGAdsAdapterInterstitialDelegate

-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidLoad");
        [adsAdapter displayInterstitial];
}

-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDisappear");
    [self setupNavigation];
       

}
-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidShown");

}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    [self setupNavigation];
    

}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    
}

-(void)setupNavigation {
    

    BannerViewController *bannerViewController = [[BannerViewController alloc] init];
    APP_DELEGATE.navigationController = [[UINavigationController alloc]initWithRootViewController:bannerViewController];
    MenuViewController *menu = [[MenuViewController alloc]init];
    APP_DELEGATE.drawerViewController = [[MABDrawerViewController alloc]initWithViewController:APP_DELEGATE.navigationController menuViewController:menu];
    [APP_DELEGATE.drawerViewController setMenuSize:214];
    APP_DELEGATE.navigationController.navigationBarHidden = YES;
    
    
    if (APP_DELEGATE.window.rootViewController.class == APP_DELEGATE.drawerViewController.class) {
          return;
      }
        APP_DELEGATE.window.rootViewController = APP_DELEGATE.drawerViewController;
      APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;
    
     APP_DELEGATE.firstCallSplash = NO;


}

@end
