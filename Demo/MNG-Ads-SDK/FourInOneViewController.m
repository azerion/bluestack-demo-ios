//
//  FourInOneViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/20/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "FourInOneViewController.h"
#import <BlueStackSDK/MNGNAtiveObject.h>

@interface FourInOneViewController (){
    //In this page we will use three types of Ads
    MNGAdsSDKFactory *nativeAdsFactory;
    MNGAdsSDKFactory *bannerAdsFactory;
    MNGAdsSDKFactory *squareBannerAdsFactory;
    MNGAdsSDKFactory *interstitialAdsFactory;
    UIView *_bannerView;
    UIView *_squareBannerView;
    int elementNbr;
    MNGNAtiveObject *_nativeObject;
    CGFloat bannerHeight;
}

@end

@implementation FourInOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    elementNbr = 0;
    [self simulateCallWS];
    [self createInterstitial];

}

-(void)simulateCallWS{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        elementNbr = 40;
        [self.tableView reloadData];
        [self.loadingIndicator stopAnimating];
        [self createSquare];
    });
}

-(void)createBanner{
    bannerAdsFactory = [[MNGAdsSDKFactory alloc]init];
    bannerAdsFactory.bannerDelegate = self;
    bannerAdsFactory.clickDelegate = self;
    bannerAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    bannerAdsFactory.placementId = MNG_ADS_BANNER_PLACEMENT_ID;
    [bannerAdsFactory loadBannerInFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
}

-(void)createSquare{
    squareBannerAdsFactory = [[MNGAdsSDKFactory alloc]init];
    squareBannerAdsFactory.bannerDelegate = self;
    squareBannerAdsFactory.clickDelegate = self;
    squareBannerAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    squareBannerAdsFactory.placementId = MNG_ADS_SQUARE_DYNAMIC_PLACEMENT_ID;
    [squareBannerAdsFactory loadBannerInFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
}

-(void)createInterstitial{
    interstitialAdsFactory = [[MNGAdsSDKFactory alloc]init];
    interstitialAdsFactory.interstitialDelegate = self;
    interstitialAdsFactory.clickDelegate = self;
    interstitialAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    interstitialAdsFactory.placementId = MNG_ADS_INTERSTITIAL_PLACEMENT_ID;
    [interstitialAdsFactory loadInterstitial];
}

-(void)createNative{
    nativeAdsFactory = [[MNGAdsSDKFactory alloc]init];
    nativeAdsFactory.nativeDelegate = self;
    nativeAdsFactory.viewController = self;
    nativeAdsFactory.clickDelegate = self;
    nativeAdsFactory.placementId = MNG_ADS_NATIVE_AD_PLACEMENT_ID;
    [nativeAdsFactory loadNative];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return elementNbr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        if (_squareBannerView) {
            [_squareBannerView removeFromSuperview];
            _squareBannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _squareBannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height);
            [cell addSubview:_squareBannerView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
            if (cell) {
                return cell;
            }
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
            cell.textLabel.text = @"Best practice Mngads : optimized use case for several ad formats on one page.";
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"x"];
        if (cell) {
            return cell;
        }
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"x"];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"article"]];
        image.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        image.frame = cell.bounds;
        [cell addSubview:image];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        if (_squareBannerView) {
            return bannerHeight;
        }
        return 0;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        if (_squareBannerView) {
            return bannerHeight;
        }
        return 0;
    }else{
        return 60;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_squareBannerView.window == self.tableView.window){
        CGFloat yPosition = [_squareBannerView convertPoint:CGPointZero  toView:self.tableView].y - scrollView.contentOffset.y;
        CGFloat YPositionPercentage = (yPosition/self.tableView.frame.size.height)*100;
        if (YPositionPercentage >=0 && YPositionPercentage <=100) {
            NSString *webviewMessage = [NSString stringWithFormat:@"%.01f", YPositionPercentage];
            NSLog(@"%.04f %@",yPosition,webviewMessage);
            [squareBannerAdsFactory sendMessageToBanner:webviewMessage];
        }
    }
}

#pragma mark - MNGAdsAdapterInterstitialDelegate

-(void)adsAdapterInterstitialDidLoad:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidLoad");
    [self createBanner];
}

-(void)adsAdapterInterstitialDisappear:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDisappear");
    
}
-(void)adsAdapterInterstitialDidShown:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"adsAdapterInterstitialDidShown");

}
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter interstitialDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    [self createBanner];
    
}

#pragma mark - MNGAdsAdapterBannerDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidLoad:(UIView *)adView preferredHeight:(CGFloat)preferredHeight{
    NSLog(@"adsAdapterBannerDidLoad:");
    if (adsAdapter == bannerAdsFactory) {
        _bannerView = adView;
        adView.frame = CGRectMake(0,0, self.view.frame.size.width, preferredHeight);
        [self.bannerContainer addSubview:adView];
        [UIView animateWithDuration:0.3 animations:^{
            self.bannerConstraint.constant = preferredHeight;
            [self.view layoutIfNeeded];
        }];
        [self createNative];
    }else{
        _squareBannerView = adView;
        bannerHeight = preferredHeight;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    if (adsAdapter == bannerAdsFactory) {
        [self createNative];
    }
}

#pragma mark - MNGAdsAdapterNativeDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidLoad:(MNGNAtiveObject *)nativeObject{
    _nativeObject = nativeObject;
    self.nativeAdTitle.text = _nativeObject.title;
    //    self.contextLabel.text = nativeObject.socialContext;
    self.nativeAdBody.text = _nativeObject.body;
    if (_nativeObject.badgeView) {
        [self.nativeAdBadgeContainer addSubview:_nativeObject.badgeView];
    }
    //download images
    self.nativeAdIcon.image = nil;
    self.nativeAdIcon.layer.cornerRadius = 9;
    self.nativeAdIcon.clipsToBounds = YES;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *imageDataIcone = [NSData dataWithContentsOfURL:_nativeObject.photoUrl];
//        UIImage *icone = [UIImage imageWithData:imageDataIcone];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.nativeAdIcon.image = icone;
//        });
//    });
    [self.nativeAdCallToAction setTitle:_nativeObject.callToAction forState:UIControlStateNormal];
    self.nativeAdCallToAction.titleLabel.textAlignment = NSTextAlignmentCenter;
    [UIView animateWithDuration:0.3 animations:^{
        self.nativeAdConstraint.constant = 50;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
//        [_nativeObject registerViewForInteraction:self.nativeAdView
//                              withViewController:[APP_DELEGATE drawerViewController]
//                               withClickableView:self.nativeAdView];
        
         [_nativeObject registerViewForInteraction:self.nativeAdView withMediaView:self.nativeAdBadgeContainer withIconImageView:self.nativeAdIcon withViewController:[APP_DELEGATE drawerViewController] withClickableView:self.nativeAdView];
    }];
    [adsAdapter releaseMemory];
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeObjectDidFailWithError:(NSError *)error withCover:(BOOL)cover{
    NSLog(@"%@",error);
    [adsAdapter releaseMemory];
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter bannerDidChangeFrame:(CGRect)frame{
    bannerHeight = frame.size.height;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
//    SET_LAST_CLICK_DATE
}
-(void)dealloc{
    [_bannerView removeFromSuperview];
    _bannerView = nil;
    [bannerAdsFactory releaseMemory];
    _nativeObject = nil ;
    [nativeAdsFactory releaseMemory];
    [interstitialAdsFactory releaseMemory];
    interstitialAdsFactory = nil;
  
    [bannerAdsFactory releaseMemory];
    bannerAdsFactory = nil;
    
    [squareBannerAdsFactory releaseMemory];
    squareBannerAdsFactory = nil;

}
@end
