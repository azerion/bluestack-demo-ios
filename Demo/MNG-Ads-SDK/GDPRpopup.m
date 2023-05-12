//
//  GDPRpopup.m
//  MNG-Ads-SDK-Demo
//
//  Created by Hussein Dimessi on 11/05/2018.
//  Copyright © 2018 MAdvertise. All rights reserved.
//

#import "GDPRpopup.h"
#import <MAdvertiseConsent.h>

@implementation GDPRpopup

- (GDPRpopup*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:@"GDPRpopup" owner:self options:nil] objectAtIndex:0];
    [rootView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:rootView];

    
    MAdvertiseConsent *currentConsent = MAdvertiseConsent.getConsent;
    
    [_consentString setText:currentConsent.consentStrings[@"IAB"]];
    _inScope.on = currentConsent.isGDPRScope;
    if (!_inScope.on) {
        [_consentString setText:@"BONlRnIONlRnIAAABAENAAAAAAAAoAA"];
    }
    
    _consentString.delegate = self;
    
    return self;
}

- (IBAction)inScopeSwitched:(UISwitch *)sender {
    _consentString.enabled = sender.on;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)gdprSettingsValidated:(id)sender {
    NSDictionary *consentDictionnary = @{@"IAB":_consentString.text};
    MAdvertiseConsent *consent = [[MAdvertiseConsent alloc]initWithGDPRScope:_inScope.on andConsentStrings:consentDictionnary];
    if ([MAdvertiseConsent setConsentInformation:consent]) {
        [_consentDescription setTextColor:[UIColor blackColor]];
        _consentDescription.text = @"Consent string";
        if ([self.delegate respondsToSelector:@selector(popupDismissed)]) {
            [self.delegate popupDismissed];
        }
        [self removeFromSuperview];
    } else {
        _consentDescription.text = @"Consent tring must be provided while inScope";
        [_consentDescription setTextColor:[UIColor redColor]];
    }
}

@end
