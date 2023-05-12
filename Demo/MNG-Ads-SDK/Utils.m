//
//  Utils.m
//  MNG-Ads-SDK-Demo
//
//  Created by Ben Salah Med Amine on 8/11/15.
//  Copyright (c) 2015 MNG. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void)displayToastWithMessage:(NSString *)toastMessage
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = toastMessage;
//        toastView.font = [MYUIStyles getToastHeaderFont];
        toastView.textColor = [UIColor whiteColor];
        toastView.numberOfLines = 0 ;
        toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width * 0.75, 100);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 1.0f
                              delay: 2.0f
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             toastView.alpha = 0.0;
                         }
                         completion: ^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }
         ];
    }];
}

+(MNGPreference *)getTestPreferences {
    MNGPreference *preferences = [[MNGPreference alloc]init];
    preferences.keyWord = @"target=mngadsdemo;version=3.0.4;semantic=https://www.google.com";
    [preferences setGender:MNGGenderMale];
    NSNumber * consentFlag = MNG_ADS_ConsentFlag ;
    preferences.location = [preferences setLocationPreferences:[APP_DELEGATE sharedLocationManager].location WithConsentFlag:consentFlag.intValue] ;
    preferences.age = 60;

    return preferences;
}

@end
