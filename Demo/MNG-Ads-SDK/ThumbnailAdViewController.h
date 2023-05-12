//
//  ThumbnailAdViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by HtrimechMac on 02/02/2021.
//  Copyright © 2021 Bensalah Med Amine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThumbnailAdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *thumbailTableView;

@property (weak, nonatomic) IBOutlet UITextField *xMarginTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *yMarginTextFiled;

@end

NS_ASSUME_NONNULL_END
