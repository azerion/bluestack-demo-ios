//
//  IMDRewardEarnedDelegate.h
//  ImproveDigital
//
//  Created by Nagib Bin Azad on 22/5/23.
//

@class IMDRewardedVideoAd;

@protocol IMDRewardEarnedDelegate <NSObject>

-(void)rewardEarnedOnRewardedVideoAd:(IMDRewardedVideoAd *)ad;

@end
