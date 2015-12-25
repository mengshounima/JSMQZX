//
//  QingyubiaoVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "GDataXMLNode.h"
#import "JKAlertDialog.h"
@interface QingyubiaoVC : UIViewController

@property (strong, nonatomic) IBOutlet EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)clickSearchBtn:(id)sender;
@end