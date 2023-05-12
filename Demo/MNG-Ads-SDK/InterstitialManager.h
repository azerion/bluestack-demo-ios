//
//  InterstitialManager.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/23/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterstitialManager : NSObject<MNGAdsAdapterInterstitialDelegate,MNGClickDelegate>

+(InterstitialManager*)sharedManager;

-(void)showInterstitial;

-(void)showInterstitialOverlay;

@end
