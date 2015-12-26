//
//  FuwuCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJStatusFrame.h"
@interface FuwuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwushequLabel;
@property (weak, nonatomic) IBOutlet UILabel *baodaoshequLabel;


-(void)updateCell:(NSDictionary *)infoDic;
@property (strong, nonatomic) IBOutlet UILabel *huodongL;
@property (nonatomic, strong) MJStatusFrame *statusFrame;
@property (strong, nonatomic) IBOutlet UILabel *dangyuanL;
@end
