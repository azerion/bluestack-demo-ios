//
//  EyesDetectionViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 08/09/2017.
//  Copyright © 2017 MAdvertise. All rights reserved.
//

#import "EyesDetectionViewController.h"

@interface EyesDetectionViewController (){
    MNGAdsSDKFactory *interstitialAdsFactory;
}

@end

@implementation EyesDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMenu:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (IBAction)loadAd:(UIButton *)sender {
    
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    if (sender.tag == 0) {
        interstitialAdsFactory.placementId = @"/2292234/demo";
    }else{
        interstitialAdsFactory.placementId = @"/2292234/showcase";
    }
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
    MNGPreference *preferences = [Utils getTestPreferences];
    [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:YES];
    
}

-(void)dealloc{
    
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory  = nil ;
    
}
@end
