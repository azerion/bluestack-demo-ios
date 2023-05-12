//
//  AppsfireViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 04/08/2017.
//  Copyright © 2017 MAdvertise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASViewController : UIViewController<MNGAdsAdapterBannerDelegate,MNGAdsAdapterRefreshDelegate, MNGAdsAdapterNativeDelegate, MNGAdsAdapterInterstitialDelegate,MNGClickDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialContext;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *callToActionButton;
@property (weak, nonatomic) IBOutlet UIView *nativeView;

    @property (weak, nonatomic) IBOutlet UIButton *bannerBtn;
    @property (weak, nonatomic) IBOutlet UIButton *squareBtn;
    @property (weak, nonatomic) IBOutlet UIButton *nativeBtn;
    @property (weak, nonatomic) IBOutlet UIButton *interBtn;

@end
