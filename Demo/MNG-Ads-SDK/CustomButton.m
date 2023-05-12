//
//  CustomButton.m
//  MNG-Ads-SDK-Demo
//
//  Created by HDimes on 2/1/19.
//  Copyright © 2019 MAdvertise. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)setBorderColor:(UIColor*)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setRounded:(BOOL)rounded {
    if (rounded) {
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
}

@end
