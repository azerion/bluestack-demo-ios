//
//  RewardVideoViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 06/09/2017.
//  Copyright © 2017 MAdvertise. All rights reserved.
//

#import "RewardVideoViewController.h"
#import <BlueStackSDK/MAdvertiseReward.h>

#import <BlueStackSDK/MAdvertiseRewardedVideoAd.h>

@interface RewardVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomShowConstraint;
@property (weak, nonatomic) IBOutlet UIView *logContainer;

@end

@implementation RewardVideoViewController {
    
    MAdvertiseRewardedVideoAd *videoAd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_logContainer.layer setCornerRadius:12];
    
    [_loadButton.layer setBorderWidth:1.0];
    [_loadButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_loadButton.layer setCornerRadius:_loadButton.frame.size.height / 2];
    
    [_showButton.layer setBorderWidth:1.0];
    [_showButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_showButton.layer setCornerRadius:_loadButton.frame.size.height / 2];
    
    [_showButton setHidden:true];
    
    // for some reason just removing the constraint doesnt effect the size of the container in here, gotta remove it, add it then remove it again for it to work
    [self.view removeConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
    
    [self.view addConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
    
    [self.view removeConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
    videoAd = [[MAdvertiseRewardedVideoAd alloc]initWithPlacementID:MNG_ADS_REWARD_VIDEO_PLACEMENT_ID];
}

- (IBAction)loadAd:(UIButton *)sender {
    [_showButton setHidden:true];
    [self.view removeConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
   
    [_logTextView setText:@""];

    [videoAd setDelegate:self];
    [videoAd loadAd];
}

- (IBAction)showAd:(UIButton *)sender {
    NSString *message = @"Video rewarded is not AdValid ";

    [_logTextView setText:@""];
    
    if (videoAd.isAdValid) {
        message = @"Video rewarded is AdValid ";
        [videoAd showAdFromRootViewController:[APP_DELEGATE drawerViewController] animated:true];
    }else{
        message = @"Video rewarded is not AdValid ";
    }
    [Utils displayToastWithMessage:message];
    NSLog(@"%@",message);
}

- (IBAction)openMenu:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (void)adsAdapterRewardedVideoAdDidLoad:(MNGAdsAdapter *)adsAdapter {
    [_showButton setHidden:false];
    [self.view addConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
}

- (void)adsAdapter:(MNGAdsAdapter *)adsAdapter rewardedVideoAdDidFailWithError:(NSError *)error {
    [_showButton setHidden:true];
    [self.view removeConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
}

- (void)adsAdapterRewardedVideoAdDidClose:(MNGAdsAdapter *)adsAdapter {
    [_showButton setHidden:true];
    [self.view removeConstraint:_bottomShowConstraint];
    [self.view layoutIfNeeded];
}

- (void)adsAdapterRewardedVideoAdDidClick:(MNGAdsAdapter *)adsAdapter {
    
}

- (void)adsAdapterRewardedVideoAdComplete:(MNGAdsAdapter *)adsAdapter withReward:(MAdvertiseReward *)reward {
    NSString *message = @"Video rewarded";
    if (reward) {
        message = [NSString stringWithFormat:@"%@ /n type: %@ /n  amount: %@ /n",message,reward.type, reward.amount];
    }
    [_logTextView setText:message];
    [Utils displayToastWithMessage:message];
}

- (void)adsAdapterRewardedVideoAdWillLogImpression:(MNGAdsAdapter *)adsAdapter {
    
}

@end
