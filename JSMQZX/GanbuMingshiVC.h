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
@interface GanbuMingshiVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)clickSearchBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
