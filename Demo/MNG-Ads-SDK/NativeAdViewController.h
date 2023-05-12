//
//  NativeAdViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/3/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
@interface NativeAdViewController : UIViewController<MNGAdsAdapterNativeDelegate,MNGClickDelegate>
@property (weak, nonatomic) IBOutlet UIView *nativeView;
@property (weak, nonatomic) IBOutlet UIView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialContextLabel;
@property (weak, nonatomic) IBOutlet UIButton *callToActionButton;
- (IBAction)openMenu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet CustomButton *withCoverBtn;
@property (weak, nonatomic) IBOutlet CustomButton *withoutCoverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconeWithouImageView;
@property (weak, nonatomic) IBOutlet UILabel *descWithoutLabel;
@property (weak, nonatomic) IBOutlet UIButton *callToactionBtnWIthout;
@property (weak, nonatomic) IBOutlet UILabel *tiltleWithouLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialCOntextWithoutLabel;
@property (weak, nonatomic) IBOutlet UIView *nativeWithouCoverView;

@end
