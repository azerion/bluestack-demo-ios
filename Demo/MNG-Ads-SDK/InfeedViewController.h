//
//  ParalaxViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 13/11/2019.
//  Copyright © 2019 Bensalah Med Amine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfeedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *infeedSview;
@property (weak, nonatomic) IBOutlet UIScrollView *infeedScrollView;
@property int index;

@end

NS_ASSUME_NONNULL_END
