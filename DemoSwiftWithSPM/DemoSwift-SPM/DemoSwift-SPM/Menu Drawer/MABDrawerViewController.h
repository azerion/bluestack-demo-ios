//
//  MABDrawerViewController.h
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/1/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MABDrawerViewController : UIViewController

-(instancetype)initWithViewController:(UIViewController *)viewController
                   menuViewController:(UIViewController *)menuViewController;

-(void)openMenu;

-(void)closeMenu;

typedef void (^CompletionBlock)(void);
@property (nonatomic, copy) CompletionBlock completionBlock;


@property CGFloat menuSize;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic)  BOOL statusBarHidden;

@end
