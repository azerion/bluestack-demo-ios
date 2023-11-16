//
//  IMDFullScreenContentDelegate.h
//  ImproveDigital
//
//  Created by Nagib Bin Azad on 22/5/23.
//

#import <ImproveDigital/IMDError.h>

@protocol IMDFullScreenPresentableAd;

NS_ASSUME_NONNULL_BEGIN

@protocol IMDFullScreenContentDelegate <NSObject>

-(void)onDisplayedAd:(id<IMDFullScreenPresentableAd>)ad;
-(void)onFailedToDisplayAd:(id<IMDFullScreenPresentableAd>)ad withError:(IMDError *)error;
-(void)onClickedAd:(id<IMDFullScreenPresentableAd>)ad;
-(void)onClosedAd:(id<IMDFullScreenPresentableAd>)ad;

@end

NS_ASSUME_NONNULL_END
