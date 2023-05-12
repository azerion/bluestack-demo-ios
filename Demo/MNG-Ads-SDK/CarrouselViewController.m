//
//  CarrouselViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/6/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "CarrouselViewController.h"
#import "CarrouselNativeView.h"

#import <BlueStackSDK/MNGNAtiveObject.h>

@interface CarrouselViewController (){
    NSMutableArray *elementsList;
    MNGAdsSDKFactory *nativeCollectionAdsFactory;
    NSInteger nativeAdCount;
    BOOL nativeWithcover;
    
}

@end

@implementation CarrouselViewController

- (void)loadCollectionNativeAdWithCover:(BOOL)cover {
    nativeCollectionAdsFactory = [[MNGAdsSDKFactory alloc]init];
    nativeCollectionAdsFactory.nativeCollectionDelegate = self;
    nativeCollectionAdsFactory.clickDelegate = self;
    nativeCollectionAdsFactory.viewController = [APP_DELEGATE drawerViewController];
    nativeCollectionAdsFactory.placementId = MNG_ADS_NATIVE_AD_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    [nativeCollectionAdsFactory createNativeCollection:5 WithPreferences:preferences WithCover:cover];
    NSLog(@"numberOfRunningFactories = %lu",(unsigned long)[MNGAdsSDKFactory numberOfRunningFactory]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nativeWithcover = YES;
    [self loadCollectionNativeAdWithCover:YES];
    
}
- (IBAction)loadCollectionWithCoverAction:(id)sender {
    nativeWithcover = YES;
    [self loadCollectionNativeAdWithCover: YES];
}
- (IBAction)loadCollectionWithOutCoverAction:(id)sender {
    nativeWithcover = NO;
    [self loadCollectionNativeAdWithCover: NO];
}

- (IBAction)openMenu:(UIButton *)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

- (void)initCarousselScrollView:(NSArray *)nativeCollection inScrollView:(UIScrollView*)scrollView {
    
}

-(void)initScrollViewWithNativeCollection:(NSArray *)nativeCollection{
   UIView *prevV;
    CGFloat heightScroll ;
    if (nativeWithcover) {
        heightScroll  = 250;
    } else {
        heightScroll  = 100;
    }
    self.carrouselScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, heightScroll)];

    self.carrouselScrollView.pagingEnabled = YES;
    self.carrouselScrollView.bounces = NO;
    self.carrouselScrollView.clipsToBounds = NO;
    self.carrouselScrollView.delegate = self;
    self.carrouselScrollView.showsHorizontalScrollIndicator = NO;
    elementsList = [[NSMutableArray alloc]init];
    nativeAdCount = nativeCollection.count;
    for (int i=0; i<nativeAdCount; i++) {
        CarrouselNativeView *v = [[CarrouselNativeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, heightScroll)];
        MNGNAtiveObject *nativeObject = [nativeCollection objectAtIndex:i];
        [self initView:v withNativeObject:nativeObject];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [self.carrouselScrollView addSubview:v];
        
        if (nativeWithcover) {
             [nativeObject registerViewForInteraction:v withMediaView:v.backgroundImage withIconImageView:v.iconeImage withViewController:[APP_DELEGATE drawerViewController] withClickableView:v];
        } else {
             [nativeObject registerViewForInteraction:v withMediaView:nil withIconImageView:v.iconeImage withViewController:[APP_DELEGATE drawerViewController] withClickableView:v];
        }
      
        
        v.backgroundImage.frame = v.frame;
        //        [nativeObject setMediaContainer:v.backgroundImage];
        NSLayoutConstraint *w = [NSLayoutConstraint constraintWithItem:v
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:self.view.frame.size.width - 30];
        NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:v
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:heightScroll];
        if (i != 0) {
            v.transform = CGAffineTransformMakeScale(0.95, 0.75);
        }
        [elementsList addObject:v];
        [v addConstraints:@[w,h]];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:v
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.carrouselScrollView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:v
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:self.carrouselScrollView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:v
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.carrouselScrollView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1
                                                                 constant:(self.view.frame.size.width - 30)*i+((self.view.frame.size.width - 30)/2)];
        [self.carrouselScrollView addConstraints:@[top,bottom,left]];
        prevV = v;
    }
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.carrouselScrollView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:prevV
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:(self.view.frame.size.width - 30)/2];
    
    [self.carrouselScrollView addConstraint:right];
    [self.carrouselScrollView layoutSubviews];
}

-(void)initView:(CarrouselNativeView *)v withNativeObject:(MNGNAtiveObject *)nativeObject{
    v.titleLabel.text = nativeObject.title;
    v.descriptionLabel.text = nativeObject.body;
    v.iconeImage.layer.cornerRadius = 16;
    v.iconeImage.clipsToBounds = YES;
   
    
    [v.callToActionButton setTitle:nativeObject.callToAction forState:UIControlStateNormal];
    if(nativeObject.displayType == MNGDisplayTypeAppInstall){
        [v.callToActionButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    }else if(nativeObject.displayType == MNGDisplayTypeContent){
        [v.callToActionButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    v.callToActionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView* badgeView = nativeObject.badgeView;
    if (badgeView) {
        CGRect frame = badgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = 3;
        badgeView.frame = frame;
        [v addSubview:badgeView];
    }
    
    UIView* adChoiceBadgeView = nativeObject.adChoiceBadgeView;
    if (adChoiceBadgeView) {
        CGRect frame = adChoiceBadgeView.frame;
        frame.origin.y = 3;
        frame.origin.x = v.frame.size.width - frame.size.width - 3;
        adChoiceBadgeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        adChoiceBadgeView.frame = frame;
        [v addSubview:adChoiceBadgeView];
        adChoiceBadgeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.carrouselScrollView) {
        return;
    }
    CGFloat targetX = scrollView.contentOffset.x;
    CGFloat targetIndex = targetX / (self.view.frame.size.width - 30);
    for (int i= 0; i<nativeAdCount; i++) {
        UIView *v = [elementsList objectAtIndex:i];
        CGFloat scale =1 - (0.05*fabs(i-targetIndex));
        if (scale>1) {
            scale = 1;
        }else if(scale < 0.95){
            scale = 0.95;
        }
        CGFloat scaley =1 - (0.25*fabs(i-targetIndex));
        if (scaley>1) {
            scaley = 1;
        }else if(scaley < 0.75){
            scaley = 0.75;
        }
        v.transform = CGAffineTransformMakeScale(scale, scaley);
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && self.carrouselScrollView) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [self.carrouselScrollView removeFromSuperview];
        self.carrouselScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.carrouselScrollView.frame = CGRectMake(15, 0, self.view.frame.size.width - 30, cell.frame.size.height);
        [cell addSubview:self.carrouselScrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
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
    if (indexPath.row == 2 && self.carrouselScrollView) {
        if (nativeWithcover) {
            return 250;
        } else {
            return 100;
        }
    }else{
        return 160;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && self.carrouselScrollView) {
         if (nativeWithcover) {
                   return 250;
               } else {
                   return 100;
               }
    }else{
        return 160;
    }
}

#pragma mark - NativeCollectionDelegate

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeCollectionDidLoad:(NSArray *)nativeCollection{
    [self initScrollViewWithNativeCollection:nativeCollection];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dealloc{
    [nativeCollectionAdsFactory releaseMemory];
}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter nativeCollectionDidFailWithError:(NSError *)error{
    
}



-(void)adsAdapterAdWasClicked:(MNGAdsAdapter *)adsAdapter{
    NSLog(@"\n/**\n *Carrousel Clicked\n **/");
    [Utils displayToastWithMessage:@"Carrousel Clicked"];
}
-(void)adsAdapterNativeAdWasClicked:(MNGAdsAdapter *)adsAdapter nativeObjectClicked:(MNGNAtiveObject *)clickedAdView{
    
   NSLog(@"\n/**\n * nativeObjectClicked Carrousel Clicked\n **/");
     [Utils displayToastWithMessage:@"Carrousel nativeObject Clicked"];
    
}


@end
