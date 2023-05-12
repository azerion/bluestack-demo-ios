//
//  MenuViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 3/12/15.
//  Copyright (c) 2015 Mng. All rights reserved.
//

#import "MenuViewController.h"
#import "BannerViewController.h"
#import "InterstitialViewController.h"
#import "NativeAdViewController.h"
#import "CarrouselViewController.h"
#import "FourInOneViewController.h"
#import "MngAdsDemo-Swift.h"
#import "PagerViewController.h"
#import "SettingsViewController.h"
#import "AppsfireViewController.h"
#import "RewardVideoViewController.h"
#import "EyesDetectionViewController.h"
#import "MASViewController.h"
#import "DFPDemoViewController.h"
//#import "MNGMPViewController.h"
#import "InfeedViewController.h"
#import "ThumbnailAdViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController {
    BOOL usingNewPlacement;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollview setContentSize:CGSizeMake(214, 925)];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInters{
    [[InterstitialManager sharedManager]showInterstitialOverlay];
}

-(void)verifyAppId {
    if (usingNewPlacement) {
        [MNGAdsSDKFactory initWithAppId:MNG_ADS_APP_ID];
        usingNewPlacement = false;
    }
}

- (IBAction)openEyesTrackingVC:(UIButton *)sender {
    if (!usingNewPlacement) {
        [MNGAdsSDKFactory initWithAppId:@"2292234"];
        usingNewPlacement = true;
    }
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[EyesDetectionViewController alloc]init]] animated:NO];
}

- (IBAction)openAfViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[AppsfireViewController alloc]init]] animated:NO];
}

- (IBAction)openMASViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[MASViewController alloc]init]] animated:NO];
}


- (IBAction)openBannerViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[BannerViewController alloc]init]] animated:NO];
}

- (IBAction)openInterstitialViewController:(UIButton *)sender {
    [self verifyAppId];
    [self showInters];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[InterstitialViewController alloc]init]] animated:NO];
}

- (IBAction)openNativeViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[NativeAdViewController alloc]init]] animated:NO];
}

- (IBAction)openCarrouselViewController:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[CarrouselViewController alloc]init]] animated:NO];
}

- (IBAction)openSwiftViewController:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[SwiftViewController alloc]init]] animated:NO];
}

- (IBAction)open4In1ViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[FourInOneViewController alloc]init]] animated:NO];
}

- (IBAction)openInfeedViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[InfeedViewController alloc]init]] animated:NO];
}

- (IBAction)openPagerViewController:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[PagerViewController alloc]init]] animated:NO];
}


- (IBAction)openSettingsViewcontroller:(id)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[SettingsViewController alloc]init]] animated:NO];
}

- (IBAction)openMiscVC:(UIButton *)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[RewardVideoViewController alloc]init]] animated:NO];
}



- (IBAction)openMopubDemo:(id)sender {
//    [self verifyAppId];
//    [[APP_DELEGATE drawerViewController]closeMenu];
//    [[APP_DELEGATE navigationController]setViewControllers:@[[[MNGMPViewController alloc]init]] animated:NO];
}


- (IBAction)openDFPDemo:(id)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[DFPDemoViewController alloc]init]] animated:NO];
}
- (IBAction)showSync:(id)sender {
    [self verifyAppId];
//    [[APP_DELEGATE drawerViewController]closeMenu];
//    [[APP_DELEGATE navigationController]setViewControllers:@[[[TestSyncViewController alloc]init]] animated:NO];
     [[APP_DELEGATE drawerViewController]closeMenu];
      [[APP_DELEGATE navigationController]setViewControllers:@[[[TestMFViewController alloc]init]] animated:NO];
}
- (IBAction)openThumbnailViewController:(id)sender {
    [self verifyAppId];
    [[APP_DELEGATE drawerViewController]closeMenu];
    [[APP_DELEGATE navigationController]setViewControllers:@[[[ThumbnailAdViewController alloc]init]] animated:NO];
}

@end

