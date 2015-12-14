//
//  SetView.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SetViewDelegate <NSObject>

- (void)SetViewUser;
- (void)SetViewSignUp;
- (void)SetViewHelp;
- (void)SetViewClose;

@end

@interface SetView : UIView
- (IBAction)clickUserBtn:(id)sender;
- (IBAction)clickSignUpBtn:(id)sender;
- (IBAction)clickHelpBtn:(id)sender;
- (IBAction)clickCloseBtn:(id)sender;
+(instancetype)sharedSetView;
@property (nonatomic,weak) id<SetViewDelegate> delegate;
@end
