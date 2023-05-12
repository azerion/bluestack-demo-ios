//
//  PagerViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 1/13/17.
//  Copyright © 2017 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerNativeViewController.h"

@interface PagerViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *pageContainerView;

@end
