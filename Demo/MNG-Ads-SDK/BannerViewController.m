//
//  BannerViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/1/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "BannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BannerViewController (){
    
    __weak UIButton *selectedSize;
    MNGAdsSDKFactory *bannerAdsFactory;
    UIView *_bannerView;
    
}

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bannerAdsFactory = [[MNGAdsSDKFactory alloc]init];
    
    if (![APP_DELEGATE sharedLocationManager]) {
        APP_DELEGATE.sharedLocationManager = [[CLLocationManager alloc]init];
        if([[APP_DELEGATE sharedLocationManager]respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [APP_DELEGATE.sharedLocationManager requestWhenInUseAuthorization];
        }
        [APP_DELEGATE.sharedLocationManager startUpdatingLocation];
    }
    
    CMPConsentManager.sharedInstance.delegate = self;
//    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];

    NSString * cmpPlistName = @"MAdvertiseCMPSettingsTCFV2_config_fr" ;
    NSString * publisherCC = @"FR" ;
//    [[NSUserDefaults standardUserDefaults]setObject:@"fr"
//                                             forKey:@"CMP_LANGUAGE"];
//    if ([language isEqual: @"en"]) {
//        cmpPlistName = @"MAdvertiseCMPSettingsTCFV2_config_en" ;
//        publisherCC = @"EN" ;
//        [[NSUserDefaults standardUserDefaults]setObject:@"en"
//                                                 forKey:@"CMP_LANGUAGE"];
//    } else if ([language isEqual: @"it"]) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"it"
//                                                 forKey:@"CMP_LANGUAGE"];
//        cmpPlistName = @"MAdvertiseCMPSettingsTCFV2_config_it" ;
//        publisherCC = @"IT" ;
//    } else if ([language isEqual: @"de"]) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"de"
//                                                 forKey:@"CMP_LANGUAGE"];
//        cmpPlistName = @"MAdvertiseCMPSettingsTCFV2_config_de" ;
//        publisherCC = @"DE" ;
//    }
    CMPLanguage *cmpLanguage = [[CMPLanguage alloc]initWithString:CMP_LANGUAGE];

   
    [CMPConsentManager.sharedInstance configure:cmpPlistName language:cmpLanguage appId:MNG_ADS_APP_ID publisherCC:publisherCC autoClose:true];
//    
    APP_DELEGATE.drawerViewController.statusBarStyle = UIStatusBarStyleLightContent;

}

// MARK: - CMPConsentManagerDelegate

- (void)consentManagerRequestsToShowConsentTool:(CMPConsentManager * _Nonnull)consentManager forVendorList:(CMPVendorList * _Nonnull)vendorList {
    if ([consentManager showConsentToolFromController:self withPopup:false]) {
        NSLog(@"------> Consent showConsentToolWithLocationFromController ");
    }
}

-(void)tcfOnConsentStringDidChange:(TCFString *)newTcfConsentString consentProvided:(NSString *)consentProvided{
    [Utils displayToastWithMessage:consentProvided];
    NSLog(@"------> Consent String changed : %@", newTcfConsentString.tcfString);
    NSLog(@"------> consentProvided changed : %@", consentProvided);

}
- (void)consentManagerRequestsToPresentPrivacyPolicyWithUrl:(NSString*)url{
    [Utils displayToastWithMessage:url];
}
-(void)consentManagerDidFailWithErrorWithError:(NSError *)error{
    [Utils displayToastWithMessage:error.localizedDescription];
    NSLog(@"------> consentManagerDidFailWithErrorWithError : %@", error.localizedDescription);
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)dealloc{
    [_bannerView removeFromSuperview];
    _bannerView = nil;
    [bannerAdsFactory releaseMemory];
}

- (IBAction)openMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (IBAction)setSize:(UIButton *)sender {
    

    if (bannerAdsFactory.isBusy) {
        NSLog(@"Ads Factory is busy");
        return;
    }
    selectedSize.selected = NO;
    selectedSize = sender;
    selectedSize.selected = YES;
    [_bannerView removeFromSuperview];
    bannerAdsFactory.bannerDelegate = self;
    bannerAdsFactory.refreshDelegate = self;
    bannerAdsFactory.clickDelegate = self;
    
    bannerAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    if (selectedSize.tag == 250) {
        bannerAdsFactory.placementId = MNG_ADS_SQUARE_BANNER_PLACEMENT_ID;
    }else{
        bannerAdsFactory.placementId = MNG_ADS_BANNER_PLACEMENT_ID;
    }
    MNGAdSize size;
    NSInteger h = selectedSize.tag;
    int width = self.view.frame.size.width;
    if (h == 250) {
        
        [_squareBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
        [_bannerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        size = kMNGAdSizeMediumRectangle;

    }else{
        
        [_bannerBtn setTitleColor:[UIColor colorWithRed:0.60 green:0.15 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
        [_squareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        BOOL isIPAD = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
        size = (isIPAD)?kMNGAdSizeDynamicLeaderboard:kMNGAdSizeBanner;
    }
    self.zoneSizeConstraint.constant = h;
    self.zoneLabel.text = [NSString stringWithFormat:@"%d X %ld",width,(long)h];
    MNGPreference *preferences = [Utils getTestPreferences];

    [bannerAdsFactory loadBannerInFrame:size withPreferences:preferences];

}


#pragma mark - MNGAdsAdapterBannerDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidLoad:(UIView *)adView preferredHeight:(CGFloat)preferredHeight{
    NSLog(@"adsAdapterBannerDidLoad:");
    _bannerView = adView;
    int width = adView.frame.size.width;
    if (preferredHeight == 250) {
        width = 300;
    }
    
    _bannerView.frame = CGRectMake((self.view.frame.size.width-width)/2, self.configView.frame.size.height - preferredHeight -10, width, preferredHeight);
    self.scrollConstraint.constant = width;
    [self.configView addSubview:_bannerView];

    _bannerView.center = self.zoneLabel.center;
    self.zoneLabel.backgroundColor =  [UIColor clearColor];
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidChangeFrame:(CGRect)frame{

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

- (IBAction)openCloseConfig:(UIButton *)sender {
    sender.selected = ! sender.selected;
    self.configView.hidden = sender.selected;
}

- (IBAction)play:(id)sender {
    [APP_DELEGATE play];
}

- (IBAction)stop:(id)sender {
    [APP_DELEGATE stop];
}
-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter {
   
        NSLog(@"----->banner clicked");
    
    
}
- (IBAction)mixedBtn:(id)sender {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

}

- (IBAction)duckBtn:(id)sender {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

}

@end
