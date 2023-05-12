//
//  BannerViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/1/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerViewController : UIViewController<MNGAdsAdapterBannerDelegate,MNGAdsAdapterRefreshDelegate,CMPConsentManagerDelegate,MNGClickDelegate>
- (IBAction)openMenu:(id)sender;
- (IBAction)setSize:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zoneSizeConstraint;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UIView *configView;
- (IBAction)openCloseConfig:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

    @property (weak, nonatomic) IBOutlet UIButton *bannerBtn;
    @property (weak, nonatomic) IBOutlet UIButton *squareBtn;
    
@end
