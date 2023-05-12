//
//  AppDelegate.h
//  MNG-Ads-SDK
//
//  Created by Mng on 12/9/14.
//  Copyright (c) 2014 Mng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MABDrawerViewController.h"
#import <BlueStackSDK/MNGAdsSDKFactory.h>
#import "InterstitialManager.h"
@import MAdvertiseCMP;
@interface AppDelegate : UIResponder <UIApplicationDelegate,MNGAdsSDKFactoryDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MABDrawerViewController *drawerViewController;
@property UINavigationController *navigationController;
@property CLLocationManager *sharedLocationManager;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property BOOL firstCallSplash;

- (void)play;
- (void)stop;

@end

