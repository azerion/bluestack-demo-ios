//
//  NativeAdViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/3/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "NativeAdViewController.h"
#import <BlueStackSDK/MNGNAtiveObject.h>

@interface NativeAdViewController (){
    MNGAdsSDKFactory *nativeAdsFactory;
    UIView *badgeView;
    UIView *adChoiceBadgeView;
    MNGNAtiveObject *_nativeObject;
    BOOL withoutCover;
}

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nativeView.hidden = YES;
    self.nativeWithouCoverView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    nativeAdsFactory = nil;
    [nativeAdsFactory releaseMemory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openMenu:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

#pragma mark - MNGAdsAdapterNativeDelegate

- (void)setupCoverView:(MNGNAtiveObject *)nativeObject {
    [self.nativeView.layer setBorderWidth:1];
    [self.nativeView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.titleLabel.text = nativeObject.title;
    self.socialContextLabel.text = nativeObject.socialContext;
    //    self.contextLabel.text = nativeObject.socialContext;
    self.descriptionLabel.text = nativeObject.body;
    if (badgeView != nil) {
        [badgeView removeFromSuperview];
    }
    _nativeObject = nativeObject;
    [_nativeObject updateBadgeTitle:@"Publicité"];
    badgeView = _nativeObject.badgeView;
    if (badgeView) {
        CGRect frame = badgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = 3;
        badgeView.frame = frame;
        [self.nativeView addSubview:badgeView];
    }
    
    if (adChoiceBadgeView != nil) {
        [adChoiceBadgeView removeFromSuperview];
    }
    adChoiceBadgeView = _nativeObject.adChoiceBadgeView;
    if (adChoiceBadgeView) {
        CGRect frame = adChoiceBadgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = self.nativeView.frame.size.width - 28 - 3;
        frame.size.height = 28;
        frame.size.width = 28;
        adChoiceBadgeView.frame = frame;
        [self.nativeView addSubview:adChoiceBadgeView];
    }
    
    
    //download images
    self.iconeImage.image = nil;
    self.iconeImage.layer.cornerRadius = 16;
    self.iconeImage.clipsToBounds = YES;
    
    
    [self.callToActionButton setTitle:_nativeObject.callToAction forState:UIControlStateNormal];
    if(_nativeObject.displayType == MNGDisplayTypeAppInstall){
        [self.callToActionButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    }else if(_nativeObject.displayType == MNGDisplayTypeContent){
        [self.callToActionButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    self.callToActionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_nativeObject registerViewForInteraction:self.nativeView withMediaView:self.backgroundImage withIconImageView:self.iconeImage withViewController:[APP_DELEGATE drawerViewController] withClickableView:self.callToActionButton];
    
    _nativeView.hidden = NO;
    _nativeWithouCoverView.hidden = YES;
}

- (void)setupWithoutCoverView:(MNGNAtiveObject *)nativeObject {
    [self.nativeWithouCoverView.layer setBorderWidth:1];
    [self.nativeWithouCoverView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.tiltleWithouLabel.text = nativeObject.title;
    self.socialCOntextWithoutLabel.text = nativeObject.socialContext;
    //    self.contextLabel.text = nativeObject.socialContext;
    self.descWithoutLabel.text = nativeObject.body;
    if (badgeView != nil) {
        [badgeView removeFromSuperview];
    }
    _nativeObject = nativeObject;
    [_nativeObject updateBadgeTitle:@"Publicité"];
    badgeView = _nativeObject.badgeView;
    if (badgeView) {
        CGRect frame = badgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = 3;
        badgeView.frame = frame;
        [self.nativeView addSubview:badgeView];
    }
    
    if (adChoiceBadgeView != nil) {
        [adChoiceBadgeView removeFromSuperview];
    }
    adChoiceBadgeView = _nativeObject.adChoiceBadgeView;
    if (adChoiceBadgeView) {
        CGRect frame = adChoiceBadgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = self.nativeWithouCoverView.frame.size.width - 28 - 3;
        frame.size.height = 28;
        frame.size.width = 28;
        adChoiceBadgeView.frame = frame;
        [self.nativeWithouCoverView addSubview:adChoiceBadgeView];
    }
    
    
    //download images
    self.iconeWithouImageView.image = nil;
    self.iconeWithouImageView.layer.cornerRadius = 16;
    self.iconeWithouImageView.clipsToBounds = YES;

    
    
    [self.callToactionBtnWIthout setTitle:_nativeObject.callToAction forState:UIControlStateNormal];
    if(_nativeObject.displayType == MNGDisplayTypeAppInstall){
        [self.callToactionBtnWIthout setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    }else if(_nativeObject.displayType == MNGDisplayTypeContent){
        [self.callToactionBtnWIthout setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    self.callToactionBtnWIthout.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_nativeObject registerViewForInteraction:self.nativeWithouCoverView withMediaView: nil withIconImageView:self.iconeWithouImageView withViewController:[APP_DELEGATE drawerViewController] withClickableView:self.callToactionBtnWIthout];
    
    
    _nativeView.hidden = YES;
    _nativeWithouCoverView.hidden = NO;
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidLoad:(MNGNAtiveObject *)nativeObject{
    
    if (withoutCover) {
        
        [self setupWithoutCoverView:nativeObject];
    } else {
        
        [self setupCoverView:nativeObject];
    }
    
 
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidFailWithError:(NSError *)error withCover:(BOOL)cover{
    NSLog(@"%@",error);
    
}
- (IBAction)withCoverBtnPressed:(id)sender {
      withoutCover = false ;
    [self loadNativeAd];
    MNGPreference *preferences = [Utils getTestPreferences];
    [nativeAdsFactory loadNativeWithPreferences:preferences withCover:YES] ;

    
}
- (void)loadNativeAd {
    [nativeAdsFactory releaseMemory];
    nativeAdsFactory = [[MNGAdsSDKFactory alloc]init];
    nativeAdsFactory.nativeDelegate = self;
    nativeAdsFactory.clickDelegate = self;
    nativeAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    if (withoutCover) {
        nativeAdsFactory.placementId = MNG_ADS_WITHOUT_NATIVE_AD_PLACEMENT_ID;

    } else {
        nativeAdsFactory.placementId = MNG_ADS_NATIVE_AD_PLACEMENT_ID;

    }
//    preferences.preferredAdChoicesPosition = MAdvertiseAdChoiceBottomLeft;
}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    [Utils displayToastWithMessage:@"NativeAd  adsAdapter Clicked"];
}
- (IBAction)withoutCoverBtnPressed:(id)sender {
    withoutCover = true ;
    [self loadNativeAd];
    MNGPreference *preferences = [Utils getTestPreferences];
    [nativeAdsFactory loadNativeWithPreferences:preferences withCover:NO] ;

}

@end
