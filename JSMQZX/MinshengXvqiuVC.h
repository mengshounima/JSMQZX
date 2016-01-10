//
//  MinshengXvqiuVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/23.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlertDialog.h"
#import "GDataXMLNode.h"
#import "PCPieChart.h"
@interface MinshengXvqiuVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet PCPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UIView *ChatContianerV;

- (IBAction)clickZJDBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJDBtn;
@property (weak, nonatomic) IBOutlet UIButton *CUNBtn;
- (IBAction)clickCUNBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *lineV;
@end
