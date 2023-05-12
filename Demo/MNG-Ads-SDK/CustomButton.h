//
//  CustomButton.h
//  MNG-Ads-SDK-Demo
//
//  Created by HDimes on 2/1/19.
//  Copyright © 2019 MAdvertise. All rights reserved.
//

#import <UIKit/UIKit.h>
#if TARGET_INTERFACE_BUILDER
typedef NS_ENUM(NSInteger, CornerStyle) {
    Off,
    Rounded,
    Custom
};
#endif

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface  CustomButton : UIButton
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL rounded;

@end

NS_ASSUME_NONNULL_END
