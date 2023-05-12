//
//  GDPRpopup.h
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 11/05/2018.
//  Copyright © 2018 MAdvertise. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDPRpopupDelegate <NSObject>

@optional

-(void)popupDismissed;

@end

@interface GDPRpopup : UIView <UITextFieldDelegate>

@property (weak) id<GDPRpopupDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *consentDescription;
@property (weak, nonatomic) IBOutlet UISwitch *inScope;
@property (weak, nonatomic) IBOutlet UITextField *consentString;

@end
