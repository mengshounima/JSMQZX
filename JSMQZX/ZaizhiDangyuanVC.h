//
//  ZaizhiDangyuanVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/17.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlertDialog.h"
#import "GDataXMLNode.h"
@interface ZaizhiDangyuanVC : UIViewController
- (IBAction)clickDWXiaShuBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DWXiaShuBtn;
@property (weak, nonatomic) IBOutlet UIButton *DWQitaBtn;
- (IBAction)clickDWQiTaBtn:(id)sender;
- (IBAction)clickSearchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *LogTableView;
@end
