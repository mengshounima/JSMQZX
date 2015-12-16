//
//  ModifyLogVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "JKAlertDialog.h"
#import "PicViewController.h"
@interface ModifyLogVC : UIViewController
@property (nonatomic,weak) NSDictionary *myLogInfo;//传递参数
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UITextField *dateF;
@property (weak, nonatomic) IBOutlet UITextField *farmerF;
@property (weak, nonatomic) IBOutlet UITextField *commonF;
@property (weak, nonatomic) IBOutlet UITextField *typeF;
@property (weak, nonatomic) IBOutlet UITextView *needTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)clickSendBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
- (IBAction)clickPicBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *FarmerView;
@property (weak, nonatomic) IBOutlet UIView *CommonView;
@property (weak, nonatomic) IBOutlet UIView *TypeView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)clickbtn1:(id)sender;
- (IBAction)clickbtn3:(id)sender;

- (IBAction)clickbtn2:(id)sender;
- (IBAction)clickbtn4:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
- (IBAction)clickbutton1:(id)sender;
- (IBAction)clickbutton2:(id)sender;
- (IBAction)clickbutton4:(id)sender;
- (IBAction)clickbutton3:(id)sender;



@end
