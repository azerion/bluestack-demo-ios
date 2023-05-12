//
//  MABDrawerViewController.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/1/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "MABDrawerViewController.h"

@interface MABDrawerViewController (){
    UIViewController *_centerVC,*_menuVC;
    UIView * _centerView;
    BOOL isOpen;
    UIView * blackView;
}

@end

@implementation MABDrawerViewController

@synthesize menuSize = _menuSize;

-(instancetype)initWithViewController:(UIViewController *)viewController
                   menuViewController:(UIViewController *)menuViewController{
    self = [super init];
    _centerVC = viewController;
    _menuVC = menuViewController;
    blackView = [[UIView alloc]init];
    blackView.userInteractionEnabled = YES;
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
    [blackView addGestureRecognizer:rec];
    [_menuVC.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanMenu:)]];
    [blackView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanMenu:)]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _centerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _menuVC.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    _centerView.autoresizesSubviews = YES;
    _centerView.clipsToBounds = YES;
    [self.view addSubview:_centerView];
    isOpen = NO;
    UIScreenEdgePanGestureRecognizer *swipeRight = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanMenuFromScreen:)];
    [swipeRight setEdges:UIRectEdgeLeft];
    [_centerView addGestureRecognizer:swipeRight];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_completionBlock) {
          _completionBlock();
    }
  
}


-(void)didPanMenuFromScreen:(UIScreenEdgePanGestureRecognizer *)recognizer{
    if (isOpen) {
        return;
    }
    CGRect frame = self.view.bounds;
    frame.origin.x = -_menuSize;
    frame.size.width = _menuSize;
    _menuVC.view.frame = frame;
    frame.origin.x = 0;
    blackView.frame = self.view.bounds;
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    [self.view addSubview:_menuVC.view];
    [_menuVC.view layoutSubviews];
    frame =_menuVC.view.frame;
    frame.origin.x = [recognizer translationInView:blackView].x - _menuSize;
    if (frame.origin.x<-frame.size.width) {
        frame.origin.x = -frame.size.width;
    }else if(frame.origin.x>0){
        frame.origin.x = 0;
    }
    _menuVC.view.frame = frame;
    blackView.alpha = frame.origin.x/frame.size.width +1;
    
    if (recognizer.state == UIGestureRecognizerStateEnded &&
        [recognizer velocityInView:blackView].x < 0) {
        isOpen = YES;
        [self closeMenu];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGRect frame = self.view.bounds;
        frame.origin.x = 0;
        frame.size.width = _menuSize;
        [UIView animateWithDuration:0.3 animations:^{
            self->_menuVC.view.frame = frame;
            self->blackView.alpha = 1;
        }completion:^(BOOL finished) {
            self->isOpen = YES;
        }];
    }
}

-(void)didPanMenu:(UIPanGestureRecognizer *)recognizer{
    if (!isOpen) {
        return;
    }
    CGRect frame =_menuVC.view.frame;
    frame.origin.x = [recognizer translationInView:blackView].x;
    if (frame.origin.x<-frame.size.width) {
        frame.origin.x = -frame.size.width;
    }else if(frame.origin.x>0){
        frame.origin.x = 0;
    }
    _menuVC.view.frame = frame;
    blackView.alpha = frame.origin.x/frame.size.width +1;
    
    if (recognizer.state == UIGestureRecognizerStateEnded &&
        [recognizer velocityInView:blackView].x < 0) {
        [self closeMenu];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGRect frame = self.view.bounds;
        frame.origin.x = 0;
        frame.size.width = _menuSize;
        [UIView animateWithDuration:0.3 animations:^{
            self->_menuVC.view.frame = frame;
            self->blackView.alpha = 1;
        }completion:^(BOOL finished) {
            self->isOpen = YES;
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_centerVC.view removeFromSuperview];
    [_centerView addSubview:_centerVC.view];
}

-(void)openMenu{
    if (isOpen) {
        return;
    }
    CGRect frame = self.view.bounds;
    frame.origin.x = -_menuSize;
    frame.size.width = _menuSize;
    _menuVC.view.frame = frame;
    frame.origin.x = 0;
    blackView.frame = self.view.bounds;
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    [self.view addSubview:_menuVC.view];
    [_menuVC.view layoutSubviews];
    [UIView animateWithDuration:0.3 animations:^{
        self->_menuVC.view.frame = frame;
        self->blackView.alpha = 1;
    }completion:^(BOOL finished) {
        self->isOpen = YES;
    }];
}

-(void)closeMenu{
    if (!isOpen) {
        return;
    }
    CGRect frame = self.view.bounds;
    frame.origin.x = -_menuSize;
    frame.size.width = _menuSize;
    [UIView animateWithDuration:0.3 animations:^{
        self->_menuVC.view.frame = frame;
        self->blackView.alpha = 0;
    }completion:^(BOOL finished) {
        [self->_menuVC.view removeFromSuperview];
        [self->blackView removeFromSuperview];
        self->isOpen = NO;
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
