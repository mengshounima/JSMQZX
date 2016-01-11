//
//  GanbuMingshiVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlertDialog.h"
#import "GDataXMLNode.h"
#import "GanbuMingshiCell.h"
#import "MingshiBanliInfoCell.h"
@interface GanbuMingshiVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

- (IBAction)clickZJDBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJDBtn;
@property (weak, nonatomic) IBOutlet UIButton *CUNBtn;
- (IBAction)clickCUNBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *InfoTableView;
@property (strong, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

