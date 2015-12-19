//
//  mailCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mailCell : UITableViewCell
-(void)updateCell:(NSDictionary *)listDic;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *ZhuangTaiL;
@property (weak, nonatomic) IBOutlet UILabel *peopleL;
@property (weak, nonatomic) IBOutlet UILabel *danweiL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@end
