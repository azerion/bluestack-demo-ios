//
//  ThumbnailAdViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 02/02/2021.
//  Copyright © 2021 Bensalah Med Amine. All rights reserved.
//

#import "ThumbnailAdViewController.h"
#import <Webkit/Webkit.h>

@interface ThumbnailAdViewController ()<BluestackThumbnailAdDelegate,UITableViewDelegate,UITableViewDataSource>{

    MNGAdsSDKFactory * thumbnailadsFactory;
    int position;
}

@end

@implementation ThumbnailAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thumbailTableView.delegate = self;
    self.thumbailTableView.dataSource = self;
    thumbnailadsFactory = [[MNGAdsSDKFactory alloc]init];
    self.xMarginTextFiled.text = @"20";
    self.yMarginTextFiled.text = @"250";

//    [self reloadThumbnailBtnPressed:nil];


}

-(void)viewDidAppear:(BOOL)animated {
    
    
}

- (IBAction)reloadThumbnailBtnPressed:(id)sender {
    [self.view endEditing:YES];
    position = 0;
    thumbnailadsFactory.thumbnailAdDelegate = self;
    thumbnailadsFactory.viewController =[APP_DELEGATE window].rootViewController;
    thumbnailadsFactory.placementId = BLUESTACK_THUMBNAIL_OGURY_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
  
    [thumbnailadsFactory loadThumbnailWithPreferences:preferences];

}

- (IBAction)topLeftBtnPressed:(id)sender {
    position = 1;
    [self.view endEditing:YES];

    thumbnailadsFactory.thumbnailAdDelegate = self;
    thumbnailadsFactory.viewController = [APP_DELEGATE window].rootViewController;
    thumbnailadsFactory.placementId = BLUESTACK_THUMBNAIL_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceTopLeft;
    [thumbnailadsFactory loadThumbnailAdInMaxWidth:300 withMaxHeight:300 withPreferences:preferences];

}
- (IBAction)topRightBtnPressed:(id)sender {
    position = 2;
    [self.view endEditing:YES];

    thumbnailadsFactory.thumbnailAdDelegate = self;
    thumbnailadsFactory.viewController = [APP_DELEGATE window].rootViewController;
    thumbnailadsFactory.placementId = BLUESTACK_THUMBNAIL_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceTopRight;
    [thumbnailadsFactory loadThumbnailAdInMaxWidth:300 withMaxHeight:300 withPreferences:preferences];
}
- (IBAction)bottomLeftPressed:(id)sender {
    position = 3;
    [self.view endEditing:YES];

    thumbnailadsFactory.thumbnailAdDelegate = self;
    thumbnailadsFactory.viewController = [APP_DELEGATE window].rootViewController;
    thumbnailadsFactory.placementId = BLUESTACK_THUMBNAIL_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceBottomLeft;
    [thumbnailadsFactory loadThumbnailAdInMaxWidth:300 withMaxHeight:300 withPreferences:preferences];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action : Menu open + Infeed tapped
- (IBAction)openMenu:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}

#pragma mark - Thumbnail Delegate
-(void)adsAdapterThumbnailAdAdLoaded:(MNGAdsAdapter *)adsAdapter{
    MNGPreference *preferences = [Utils getTestPreferences];
    [self.view endEditing:YES];

    switch (position) {
        case 0:
//            preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceBottomRight;
            [thumbnailadsFactory showThumbnail];
            return;

        case 1:
            preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceTopLeft;
            break;
        case 2:
            preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceTopRight;
            break;
        case 3:
            preferences.preferredThumbnailAdChoicePosition = BlueStackAdChoiceBottomLeft;
            break;
        default:
           
            break;
    }
    int xmarginText = 120 ;
    int ymarginText = 120 ;

    if (self.xMarginTextFiled.text != nil) {
        xmarginText  = [self.xMarginTextFiled.text intValue];
    }
    if (self.yMarginTextFiled.text != nil) {
        ymarginText  = [self.yMarginTextFiled.text intValue];
    }
    [thumbnailadsFactory showThumbnailInGravity:preferences inXMargin:xmarginText inyMargin:ymarginText];


}
-(void)adsAdapterThumbnailAdAdError:(MNGAdsAdapter *)adsAdapter withError:(NSError *)error{
    [self.view endEditing:YES];

    
}
-(void)adsAdapterThumbnailAdAdClicked:(MNGAdsAdapter *)adsAdapter{
    
}
-(void)adsAdapterThumbnailAdAdClosed:(MNGAdsAdapter *)adsAdapter{
    
}
-(void)adsAdapterThumbnailAdAdDisplayed:(MNGAdsAdapter *)adsAdapter{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
        [cell.contentView addSubview:image];
        return cell;
}

-(void)dealloc{
    [thumbnailadsFactory releaseMemory];
    thumbnailadsFactory   = nil;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 120;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
@end

