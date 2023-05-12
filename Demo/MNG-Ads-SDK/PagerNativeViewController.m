//
//  PagerNativeViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 1/13/17.
//  Copyright © 2017 MNG. All rights reserved.
//

#import "PagerNativeViewController.h"
#import <BlueStackSDK/MNGNAtiveObject.h>

@interface PagerNativeViewController (){
    MNGAdsSDKFactory *nativeAdsFactory;
    UIView *badgeView;
    UIView *adChoiceBadgeView;
    MNGNAtiveObject *_nativeObject;
}

@end

@implementation PagerNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pubView.hidden = true;
    if (_index == 2) {
        [_activityIndicator startAnimating];
        nativeAdsFactory = [[MNGAdsSDKFactory alloc]init];
        nativeAdsFactory.nativeDelegate = self;
        nativeAdsFactory.viewController = self;
        nativeAdsFactory.placementId = MNG_ADS_NATIVE_AD_PLACEMENT_ID;
        MNGPreference *preferences = [Utils getTestPreferences];
        [nativeAdsFactory loadNativeWithPreferences:preferences];
    }
}

-(void)dealloc{
    [nativeAdsFactory releaseMemory];
    nativeAdsFactory = nil;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.height > self.view.frame.size.width) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.descriptionLabel.textColor = [UIColor blackColor];
    }else{
        self.titleLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - MNGAdsAdapterNativeDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidLoad:(MNGNAtiveObject *)nativeObject{
    [self.pubView.layer setBorderWidth:1];
    [self.pubView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.titleLabel.text = nativeObject.title;
    self.socialContextLabel.text = nativeObject.socialContext;
    //    self.contextLabel.text = nativeObject.socialContext;
    self.descriptionLabel.text = nativeObject.body;
    if (badgeView != nil) {
        [badgeView removeFromSuperview];
    }
    _nativeObject = nativeObject;
    badgeView = _nativeObject.badgeView;
    if (badgeView) {
        [self.badgeContainer addSubview:badgeView];
    }
    
    if (adChoiceBadgeView != nil) {
        [adChoiceBadgeView removeFromSuperview];
    }
    adChoiceBadgeView = _nativeObject.adChoiceBadgeView;
    if (adChoiceBadgeView) {
        
        [self.adChoiceContainer addSubview:adChoiceBadgeView];
    }
    
    
    //download images
    self.backgroundImage.image = nil;
    self.iconImage.image = nil;
    self.iconImage.clipsToBounds = YES;
  
    
    [self.callToActionButton setTitle:_nativeObject.callToAction forState:UIControlStateNormal];
    if(_nativeObject.displayType == MNGDisplayTypeAppInstall){
        [self.callToActionButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    }else if(_nativeObject.displayType == MNGDisplayTypeContent){
        [self.callToActionButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    self.callToActionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_nativeObject registerViewForInteraction:self.pubView withMediaView:self.backgroundImage withIconImageView:self.iconImage withViewController:[APP_DELEGATE drawerViewController] withClickableView:self.callToActionButton];
    self.pubView.hidden = NO;
    
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidFailWithError:(NSError *)error withCover:(BOOL)cover{
    [_activityIndicator stopAnimating];
    NSLog(@"%@",error);
}

@end
