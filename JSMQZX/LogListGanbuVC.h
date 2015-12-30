//
//  LogListGanbuVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/16.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "JKAlertDialog.h"
#import "ganbuLogCell.h"
@interface LogListGanbuVC : UIViewController
- (IBAction)clickZJDBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJDBtn;
@property (weak, nonatomic) IBOutlet UIButton *CUNBtn;
- (IBAction)clickCUNBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *LogTableView;
@property (assign,nonatomic) NSNumber *flagLogZT;
@end
