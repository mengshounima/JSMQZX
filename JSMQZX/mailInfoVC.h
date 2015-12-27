//
//  mailInfoVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
@interface mailInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *IDLABEL;
@property (weak, nonatomic) IBOutlet UILabel *bianhaoL;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiL;
@property (weak, nonatomic) IBOutlet UILabel *sendPeopleL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *toPeopleL;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *contentL;
@property (strong, nonatomic) IBOutlet UILabel *reply;
@property (weak,nonatomic) NSNumber *IDNum;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@end
