//
//  NonghuZoufangVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"
#import "JKAlertDialog.h"
#import "GDataXMLNode.h"
#define PIE_HEIGHT 300
@interface NonghuZoufangVC : UIViewController<PieChartDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)clickSearchBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *lineV;

@end
