//
//  GanbuZFInfoCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/11.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "GanbuZFInfoCell.h"

@implementation GanbuZFInfoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCellWithInfoDic:(NSDictionary *)infoDic{
    MyLog(@"%@",infoDic);
   //NSDictionary *paramDic =  @{@"name":_gl_zsxmArr[indexPath.row],@"gl_zfl":_gl_zflArr[indexPath.row],@"gl_zfjcf":_gl_zfjcfArr[indexPath.row],@"gl_zffjf":_gl_zffjfArr[indexPath.row],@"gl_zfhj":_gl_zfhjArr[indexPath.row]};
    
    
    _nameL.text = [infoDic objectForKey:@"name"];
    
    NSNumber *pingjia = [infoDic objectForKey:@"gl_zfl"];
    _zongpinjiaL.text = [NSString stringWithFormat:@"走访率：%.2f%%（应走0户，实走0户）",pingjia.floatValue];
    
    
    NSNumber *zfl =  [infoDic objectForKey:@"gl_zfhj"];
    _ZouFangLvL.text = [NSString stringWithFormat:@"%.1f",zfl.floatValue];
    
    NSNumber *bjl =  [infoDic objectForKey:@"gl_zfjcf"];
    _BanJieLv.text = [NSString stringWithFormat:@"%.1f",bjl.floatValue];
    
    NSNumber *myl =  [infoDic objectForKey:@"gl_zffjf"];
    _ManYiDuL.text = [NSString stringWithFormat:@"%.1f)",myl.floatValue];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
