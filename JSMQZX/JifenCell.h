//
//  JifenCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JifenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *zongfenL;
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;

@property (weak, nonatomic) IBOutlet UILabel *Label4;
@property (weak, nonatomic) IBOutlet UILabel *Label5;
@property (weak, nonatomic) IBOutlet UILabel *Label6;
-(void)updateCell:(NSDictionary *)infoDic;
@end
