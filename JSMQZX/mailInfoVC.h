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
@property (strong, nonatomic) IBOutlet UILabel *IDLABEL;
@property (strong, nonatomic) IBOutlet UILabel *bianhaoL;
@property (strong, nonatomic) IBOutlet UILabel *zhuangtaiL;
@property (strong, nonatomic) IBOutlet UILabel *sendPeopleL;
@property (strong, nonatomic) IBOutlet UILabel *dateL;
@property (strong, nonatomic) IBOutlet UILabel *addressL;
@property (strong, nonatomic) IBOutlet UILabel *phoneL;
@property (strong, nonatomic) IBOutlet UILabel *toPeopleL;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *contentL;
@property (strong, nonatomic) IBOutlet UILabel *reply;
@property (weak,nonatomic) NSNumber *IDNum;
@end
