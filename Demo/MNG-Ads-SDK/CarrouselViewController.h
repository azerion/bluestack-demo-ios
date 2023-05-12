//
//  CarrouselViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/6/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarrouselViewController : UIViewController<UITableViewDataSource,MNGAdsAdapterNativeCollectionDelegate,UIScrollViewDelegate,UITableViewDelegate,MNGClickDelegate>
@property UIScrollView *carrouselScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)openMenu:(UIButton *)sender;

@end
