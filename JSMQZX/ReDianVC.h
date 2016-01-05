//
//  ReDianVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/5.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "JKAlertDialog.h"
#import "LogCell.h"
#import "GanbuLogDetailWeiVC.h"
@interface ReDianVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;
- (IBAction)clickZJDBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJDBtn;
@property (weak, nonatomic) IBOutlet UIButton *CUNBtn;
- (IBAction)clickCUNBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *rizhiTableView;
@end
