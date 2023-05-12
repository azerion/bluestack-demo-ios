//
//  FourInOneViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/20/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourInOneViewController : UIViewController<MNGAdsAdapterNativeDelegate,MNGAdsAdapterBannerDelegate,MNGAdsAdapterInterstitialDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)openMenu:(id)sender;
//NATIVE AD
@property (weak, nonatomic) IBOutlet UIView *nativeAdView;
@property (weak, nonatomic) IBOutlet UIImageView *nativeAdIcon;
@property (weak, nonatomic) IBOutlet UILabel *nativeAdTitle;
@property (weak, nonatomic) IBOutlet UILabel *nativeAdBody;
@property (weak, nonatomic) IBOutlet UIButton *nativeAdCallToAction;
@property (weak, nonatomic) IBOutlet UIView *nativeAdBadgeContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nativeAdConstraint;

//BANNER
@property (weak, nonatomic) IBOutlet UIView *bannerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerConstraint;
//SQUARE
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
