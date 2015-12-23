//
//  EvaluateCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/24.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNumL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *zongpinjiaL;
@property (weak, nonatomic) IBOutlet UILabel *sszL;
@property (weak, nonatomic) IBOutlet UILabel *ZouFangLvL;
@property (weak, nonatomic) IBOutlet UILabel *BanJieLv;
@property (weak, nonatomic) IBOutlet UILabel *ManYiDuL;
-(void)updateCellWithInfoDic:(NSDictionary *)infoDic;
@end
