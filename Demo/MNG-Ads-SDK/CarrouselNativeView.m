//
//  CarrouselNetiveView.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 4/7/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "CarrouselNativeView.h"

@implementation CarrouselNativeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSubViews];
    return self;
}

-(void)initSubViews{
    self.backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backgroundImage];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    self.backgroundImage.clipsToBounds = YES;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.backgroundImage
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.backgroundImage
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.backgroundImage
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.backgroundImage
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0];
    [self addConstraints:@[top,bottom,left,right]];
    //
    UIView *hud = [[UIView alloc]init];
    hud.translatesAutoresizingMaskIntoConstraints = NO;
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self addSubview:hud];
    bottom = [NSLayoutConstraint constraintWithItem:hud
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0];
    left = [NSLayoutConstraint constraintWithItem:hud
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1
                                         constant:0];
    right = [NSLayoutConstraint constraintWithItem:self
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:hud
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1
                                          constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:hud
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:70];
    [hud addConstraint:height];
    [self addConstraints:@[bottom,left,right]];
    //
    self.iconeImage = [[UIImageView alloc]init];
    self.iconeImage.translatesAutoresizingMaskIntoConstraints = NO;
    [hud addSubview:self.iconeImage];
    
    top = [NSLayoutConstraint constraintWithItem:self.iconeImage
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:hud
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0];
    left = [NSLayoutConstraint constraintWithItem:self.iconeImage
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:hud
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1
                                         constant:5];
    height = [NSLayoutConstraint constraintWithItem:self.iconeImage
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:60];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.iconeImage
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:60];
    [hud addConstraints:@[top,left]];
    [self.iconeImage addConstraints:@[height,width]];
    //
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [hud addSubview:self.titleLabel];
    top = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:hud
                                       attribute:NSLayoutAttributeTop
                                      multiplier:1
                                        constant:10];
    left = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.iconeImage
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:5];
    [hud addConstraints:@[top,left]];
    //
    self.descriptionLabel = [[UILabel alloc]init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [UIFont systemFontOfSize:12];
    self.descriptionLabel.numberOfLines = 2;
    [hud addSubview:self.descriptionLabel];
    top = [NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.titleLabel
                                       attribute:NSLayoutAttributeBottom
                                      multiplier:1
                                        constant:10];
    left = [NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.iconeImage
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:7];
    [hud addConstraints:@[top,left]];
    //
    self.callToActionButton = [[UIButton alloc]init];
    self.callToActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.callToActionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.callToActionButton.backgroundColor = [UIColor colorWithRed:0.305
                                                              green:0.772
                                                               blue:0.243
                                                              alpha:1];
    [self.callToActionButton setUserInteractionEnabled:NO];
    [hud addSubview:self.callToActionButton];
    top = [NSLayoutConstraint constraintWithItem:self.callToActionButton
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:hud
                                       attribute:NSLayoutAttributeTop
                                      multiplier:1
                                        constant:17];
    bottom = [NSLayoutConstraint constraintWithItem:hud
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.callToActionButton
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:17];
    left = [NSLayoutConstraint constraintWithItem:self.callToActionButton
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.descriptionLabel
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:5];
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:self.callToActionButton
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.titleLabel
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:5];
    right = [NSLayoutConstraint constraintWithItem:hud
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.callToActionButton
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1
                                          constant:5];
    width = [NSLayoutConstraint constraintWithItem:self.callToActionButton
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                          constant:120];
    [hud addConstraints:@[top,bottom,left,left2,right]];
    [self.callToActionButton addConstraint:width];
}

@end
