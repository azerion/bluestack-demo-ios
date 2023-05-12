//
//  MenuViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 3/12/15.
//  Copyright (c) 2015 Mng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<MNGAdsAdapterInterstitialDelegate>
- (IBAction)openBannerViewController:(UIButton *)sender;
- (IBAction)openInterstitialViewController:(UIButton *)sender;
- (IBAction)openNativeViewController:(UIButton *)sender;
- (IBAction)openCarrouselViewController:(UIButton *)sender;
- (IBAction)openSwiftViewController:(UIButton *)sender;
- (IBAction)open4In1ViewController:(UIButton *)sender;
- (IBAction)openInfeedViewController:(UIButton *)sender;
- (IBAction)openPagerViewController:(UIButton *)sender;
- (IBAction)openSettingsViewcontroller:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
    @property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end
