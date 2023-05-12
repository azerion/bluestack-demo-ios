//
//  InterstitialViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/3/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "InterstitialViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface InterstitialViewController (){
    MNGAdsSDKFactory *interstitialAdsFactory;
    BOOL autoDisplay;
}

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCornersButton:_showIntersButton];
    [self setCornersButton:_displayIntersButton];
//    [self setCornersButton:_ovelayBtn];
//    [self setCornersButton:_interBtn];

}

-(void)setCornersButton:(UIButton *) sender{
     [sender.layer setBorderWidth:1.0];
     [sender.layer setBorderColor:[UIColor lightGrayColor].CGColor];
     [sender.layer setCornerRadius:sender.frame.size.height / 2];
}
- (IBAction)openMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (IBAction)openCloseConfig:(UIButton *)sender {
    sender.selected = ! sender.selected;
    self.configView.hidden = sender.selected;
}

- (IBAction)createInters:(UIButton *)sender {
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
    MNGPreference *preferences = [Utils getTestPreferences];
    [self.activityIndicatorView startAnimating];
    self.displayIntersButton.hidden = YES;
    self.showIntersButton.hidden = YES;
    if (sender.tag == 1) {
        autoDisplay = NO;
        interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_PLACEMENT_ID;
        [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:NO];
    }else{
        autoDisplay = YES;
        
        interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_OVERLAY_PLACEMENT_ID;
        [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:YES];
        
    }
    APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;
    
}

#pragma mark - MNGAdsAdapterInterstitialDelegate

-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidLoad");
    if (adsAdapter == interstitialAdsFactory) {
        if (autoDisplay) {
            self.showIntersButton.hidden = YES;
            self.displayIntersButton.hidden = YES;
        } else {
            self.showIntersButton.hidden = NO;
            self.displayIntersButton.hidden = NO;
        }
        
    }
    
    [self.activityIndicatorView stopAnimating];
    
}

-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDisappear");
    
    self.displayIntersButton.hidden = YES;
    self.showIntersButton.hidden = YES;
    
}
-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidShown");

}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    
    NSLog(@"%@",error);
    [self.activityIndicatorView stopAnimating];
}

-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter {
    if (adsAdapter == interstitialAdsFactory) {
        NSLog(@"----->Inter1 clicked");
    }
    
}


- (IBAction)showInters:(UIButton*)sender {
    if ([interstitialAdsFactory isInterstitialReady]) {
        if(sender.tag == 0){
            [interstitialAdsFactory showAdFromRootViewController:[APP_DELEGATE drawerViewController] animated:YES];
        }else if (sender.tag == 1){
            [interstitialAdsFactory displayInterstitial];
        }
        
    }
}
-(void)dealloc{
 
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = nil;
  
}
@end
