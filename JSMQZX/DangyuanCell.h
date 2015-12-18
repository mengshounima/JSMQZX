//
//  DangyuanCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/18.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DangyuanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *shequL;
@property (weak, nonatomic) IBOutlet UILabel *dwL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *workDanweiL;
@property (weak, nonatomic) IBOutlet UILabel *familyL;
-(void)updateCell:(NSDictionary *)infoDic;
@end
