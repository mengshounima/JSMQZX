//
//  SetView.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "SetView.h"

@implementation SetView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
}
+(instancetype)sharedSetView{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetView" owner:nil options:nil];
    return [nib lastObject];
}

- (IBAction)clickUserBtn:(id)sender {
    [self.delegate SetViewUser];
}

- (IBAction)clickSignUpBtn:(id)sender {
     [self.delegate SetViewSignUp];
}

- (IBAction)clickHelpBtn:(id)sender {
     [self.delegate SetViewHelp];
}

- (IBAction)clickCloseBtn:(id)sender {
     [self.delegate SetViewClose];
}
@end
