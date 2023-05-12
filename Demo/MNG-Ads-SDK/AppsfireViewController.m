//
//  AppsfireViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 04/08/2017.
//  Copyright © 2017 MAdvertise. All rights reserved.
//

#import "AppsfireViewController.h"
#import <BlueStackSDK/MNGNAtiveObject.h>

@interface AppsfireViewController () {
    MNGAdsSDKFactory *bannerAdsFactory;
    MNGNAtiveObject *_nativeObject;
    MNGAdsSDKFactory *nativeAdsFactory;
    MNGAdsSDKFactory *interstitialAdsFactory;
    UIView *badgeView;
    UIView *adChoiceBadgeView;
    UIView *_bannerView;
}

@end

@implementation AppsfireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)openMenu:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (IBAction)createHimono:(UIButton *)sender {
    

    [_bannerBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
    [_squareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nativeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_interBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (bannerAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    bannerAdsFactory = [[MNGAdsSDKFactory alloc]init];
    [_bannerView removeFromSuperview];
    bannerAdsFactory.bannerDelegate = self;
    bannerAdsFactory.refreshDelegate = self;
    bannerAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    bannerAdsFactory.placementId = MNG_ADS_HIMONO_PLACEMENT_ID;
    MNGAdSize size;
    
    BOOL isIPAD = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    size = (isIPAD)?kMNGAdSizeDynamicLeaderboard:kMNGAdSizeDynamicBanner;
    
    MNGPreference *preferences = [Utils getTestPreferences];
    [bannerAdsFactory loadBannerInFrame:size withPreferences:preferences];
}


- (IBAction)createSashimi:(UIButton *)sender {
    
    [_squareBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
    [_bannerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nativeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_interBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (bannerAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    [_nativeView setHidden:true];
    bannerAdsFactory = [[MNGAdsSDKFactory alloc]init];
    [_bannerView removeFromSuperview];
    bannerAdsFactory.bannerDelegate = self;
    bannerAdsFactory.refreshDelegate = self;
    bannerAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    bannerAdsFactory.placementId = MNG_ADS_SASHIMI_PLACEMENT_ID;
    MNGAdSize size;
    
    size = kMNGAdSizeMediumRectangle;
    
    MNGPreference *preferences = [Utils getTestPreferences];
    [bannerAdsFactory loadBannerInFrame:size withPreferences:preferences];
}

- (IBAction)createNativeAf:(UIButton *)sender {
    _nativeObject = nil;
    [_nativeBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
    [_squareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bannerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_interBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_bannerView removeFromSuperview];
    self.nativeView.hidden = YES;
    nativeAdsFactory = [[MNGAdsSDKFactory alloc]init];
    nativeAdsFactory.nativeDelegate = self;
    nativeAdsFactory.clickDelegate = self;
    nativeAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    nativeAdsFactory.placementId = MNG_ADS_NATIVE_AF_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    [nativeAdsFactory loadNativeWithPreferences:preferences];
}

- (IBAction)createInterAf:(UIButton *)sender {
    
    [_interBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
    [_squareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nativeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bannerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (interstitialAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    interstitialAdsFactory.placementId = MNG_ADS_INTERAF_PLACEMENT_ID;
    /**
     * MNGPrefence is the same for all ad types
     * @important: your application can be rejected by Apple if you use the device's location only for advertising
     **/
    MNGPreference *preferences = [Utils getTestPreferences];
    
    [interstitialAdsFactory loadInterstitialWithPreferences:preferences autoDisplayed:YES];
}

#pragma mark - MNGAdsAdapterNativeDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidLoad:(MNGNAtiveObject *)nativeObject{
    [self.nativeView.layer setBorderWidth:1];
    [self.nativeView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.titleLabel.text = nativeObject.title;
    self.socialContext.text = nativeObject.socialContext;
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
        frame.origin.x = self.nativeView.frame.size.width - frame.size.width - 3;
        adChoiceBadgeView.frame = frame;
        [self.nativeView addSubview:adChoiceBadgeView];
    }
    
    
    //download images
    self.backgroundImage.image = nil;
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
    
    [_nativeObject registerViewForInteraction:self.nativeView withMediaView:self.backgroundImage withIconImageView:nil withViewController:[APP_DELEGATE drawerViewController] withClickableView:self.callToActionButton];
    self.nativeView.hidden = NO;
    
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - MNGAdsAdapterBannerDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidLoad:(UIView *)adView preferredHeight:(CGFloat)preferredHeight{
    NSLog(@"adsAdapterBannerDidLoad:");
    [_bannerView removeFromSuperview];
    _bannerView = adView;
    int width = self.view.frame.size.width;
    if (preferredHeight == 250) {
        width = 300;
    }
    adView.frame = CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height - 44) - preferredHeight, width, preferredHeight);
    
  
//
//    if (@available(iOS 11, *)) {
//        UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
//        [adView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
//        [adView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
//        [adView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
//        [adView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
//    } else {
//        UILayoutGuide *margins = self.view.layoutMarginsGuide;
//        [adView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
//        [adView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
//        [adView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
//        [adView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
//
//    }
    [self.view addSubview:adView];
    if (width == 300) {
        adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }else{
        adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    }
    adView.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView * view in adView.subviews) {
        //ALIGN SIZE OF PARENT
        
        CGRect frame = adView.frame;
        frame.size.height = view.frame.size.height;
        frame.size.width = view.frame.size.width;
        adView.frame = frame;
        NSLog(@"subview frame %@",NSStringFromCGRect (frame));
        NSLog(@"ad frame %@",NSStringFromCGRect (adView.frame));
    }
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidChangeFrame:(CGRect)frame{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    _bannerView.frame = CGRectMake((self.view.frame.size.width-width)/2, self.view.frame.size.height - height, width, height);
    
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)adsAdapterBannerDidRefresh:(MNGAdsAdapter *)adsAdapter{
    [Utils displayToastWithMessage:@"banner refreshed"];
}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidFailToRefreshWithError:(NSError *)error{
    [Utils displayToastWithMessage:@"banner fail to refresh"];
}

#pragma mark - MNGAdsAdapterInterstitialDelegate

-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidLoad");
}

-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDisappear");
    
}
-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidShown");

}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    
    NSLog(@"%@",error);
}

-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter {
    NSLog(@"----->Inter clicked");
}

-(void)dealloc{
    [_bannerView removeFromSuperview];
    _bannerView = nil;
    [bannerAdsFactory releaseMemory];
    _nativeObject = nil ;
    [nativeAdsFactory releaseMemory];
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = nil;
  
}
@end
