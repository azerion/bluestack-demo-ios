//
//  PagerNativeViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 1/13/17.
//  Copyright © 2017 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerNativeViewController : UIViewController<MNGAdsAdapterNativeDelegate>

@property (weak, nonatomic) IBOutlet UIView *pubView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialContextLabel;
@property (weak, nonatomic) IBOutlet UIButton *callToActionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property int index;
@property (weak, nonatomic) IBOutlet UIView *badgeContainer;

@property (weak, nonatomic) IBOutlet UIView *adChoiceContainer;
@end
