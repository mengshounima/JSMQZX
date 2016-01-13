//
//  QingyubiaoVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GDataXMLNode.h"
#import "JKAlertDialog.h"
#import "BarChartView.h"
@interface QingyubiaoVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet BarChartView *BarChat;
- (IBAction)clickZJDBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJDBtn;
@property (weak, nonatomic) IBOutlet UIButton *CUNBtn;
- (IBAction)clickCUNBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;
@end
