//
//  XinyuanCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinyuanCellFrame.h"
@interface XinyuanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *jiduL;
@property (weak, nonatomic) IBOutlet UILabel *cunL;

@property (strong, nonatomic) IBOutlet UILabel *contentL;
@property (strong, nonatomic) IBOutlet UILabel *finishL;
@property (strong, nonatomic) IBOutlet UILabel *dateL;
-(void)updateWithInfoDic:(NSDictionary *) infoDic;
@property (nonatomic, strong) XinyuanCellFrame *statusFrame;
@end
