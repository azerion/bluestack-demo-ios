//
//  InterstitialViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/3/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterstitialViewController : UIViewController<MNGAdsAdapterInterstitialDelegate,MNGClickDelegate>
- (IBAction)openMenu:(id)sender;
- (IBAction)openCloseConfig:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *configView;
- (IBAction)createInters:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showIntersButton;
@property (weak, nonatomic) IBOutlet UIButton *displayIntersButton;

- (IBAction)showInters:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *ovelayBtn;
@property (weak, nonatomic) IBOutlet UIButton *interBtn;
@end
