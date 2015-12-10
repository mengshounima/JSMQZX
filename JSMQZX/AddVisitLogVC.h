//
//  AddVisitLogVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/8.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FarmersVC.h"
@interface AddVisitLogVC : UIViewController
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

@end
