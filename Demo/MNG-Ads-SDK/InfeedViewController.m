//
//  ParalaxViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 13/11/2019.
//  Copyright © 2019 Bensalah Med Amine. All rights reserved.
//

#import "InfeedViewController.h"

#define infeeRowPosition 8

@interface InfeedViewController ()<MNGAdsAdapterInfeedDelegate>{
    MNGAdsSDKFactory *infeedAdsFactory;
    UIView *_infeedView;
    BOOL checkTableView;
}

@end

@implementation InfeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self loadTableView:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) orientationChanged:(NSNotification *)note
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:infeeRowPosition inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [infeedAdsFactory releaseMemory];
    infeedAdsFactory   = nil;
    
    
}
- (IBAction)openMenuView:(id)sender {
    [[APP_DELEGATE drawerViewController]openMenu];
}
- (void)loadInfeedView {
    if (_infeedView) {
        [_infeedView removeFromSuperview];
        _infeedView = nil;
    }
    
    if (!checkTableView) {
        [self.tableView reloadData];
    }
   
    infeedAdsFactory = [[MNGAdsSDKFactory alloc]init];
    infeedAdsFactory.infeedDelegate = self;
    infeedAdsFactory.viewController = [APP_DELEGATE window].rootViewController;
    infeedAdsFactory.placementId = MNG_ADS_INFEED_PLACEMENT_ID;
    MNGPreference *preferences = [Utils getTestPreferences];
    
    MAdvertiseInfeedFrame * frameinfeed = [[MAdvertiseInfeedFrame alloc] initWithWidthDP:self.view.frame.size.width andInfeedRatio:INFEED_RATIO_16_9];
    [infeedAdsFactory loadInfeedInFrame:frameinfeed withPreferences:preferences];
    
}

- (IBAction)loadTableView:(id)sender {
  
    self.tableView.hidden = NO;
    self.infeedScrollView.hidden = YES;
    checkTableView = NO;
    [self loadInfeedView];
    
}

#pragma mark - Infeed Delegate
-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter infeedDidLoad:(UIView *)adView preferredHeight:(CGFloat)preferredHeight{
    NSLog(@"adsAdapterInfeedDidLoad:preferredHeight: %f",preferredHeight);
    _infeedView = adView;
    _infeedView.frame = CGRectMake((self.view.bounds.size.width - adView.bounds.size.width )/2, 0, adView.bounds.size.width, adView.bounds.size.height);
    if (checkTableView) {
        if (_infeedView) {
            [_infeedSview addSubview:_infeedView];
        }

    } else {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:infeeRowPosition inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

-(void)adsAdapter:(MNGAdsAdapter *)adsAdapter infeedDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    _infeedView = nil;
    if (!checkTableView) {
        [self.tableView reloadData];
    }
}
-(void)viewDidLayoutSubviews{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == infeeRowPosition) {
        static NSString *CellIdentifier = @"paralax";
           UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

//        = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

//           if (cell == nil)
//           {
//           }
    
        if (_infeedView) {
            [cell.contentView addSubview:_infeedView];
            [cell.contentView setClipsToBounds:YES];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];


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
    if (indexPath.row == infeeRowPosition) {
        if (_infeedView) {
           return self.view.frame.size.width * (3./5.) ;//_infeedView.frame.size.height;
        }
        return 0;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == infeeRowPosition) {
        if (_infeedView) {
            return self.view.frame.size.width * (3./5.) ;//_infeedView.frame.size.height;
        }
        return 0;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == infeeRowPosition) {
        NSLog(@"index %ld",(long)indexPath.row);
    }else {
        NSLog(@"tableview seletected here %ld",(long)indexPath.row);
    }
}

- (IBAction)loadScrollView:(id)sender {
    self.tableView.hidden = YES;
    self.infeedScrollView.hidden = NO;
    checkTableView = YES;
    [self loadInfeedView];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
