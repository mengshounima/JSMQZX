//
//  LoginVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/3.
//  Copyright (c) 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTypeView.h"
#import "GDataXMLNode.h"
#import "RootVC.h"
@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *typeF;
@property (weak, nonatomic) IBOutlet UITextField *userIDF;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
- (IBAction)clickRememberBtn:(id)sender;
- (IBAction)clickSelectBtn:(id)sender;
- (IBAction)clickLoginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;

@end
