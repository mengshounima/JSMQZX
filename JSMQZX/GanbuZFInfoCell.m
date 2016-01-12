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
   /*NSDictionary *paramDic =  @{@"name":_gl_zsxmArr[indexPath.row],@"gl_zfl":_gl_zflArr[indexPath.row],@"gl_zfjcf":_gl_zfjcfArr[indexPath.row],@"gl_zffjf":_gl_zffjfArr[indexPath.row],@"gl_zfhj":_gl_zfhjArr[indexPath.row]};
    @"zjd_cgb_zfnhs":_zjd_cgb_zfnhsArr[indexPath.row],@"zjd_cgb_zfrzs":_zjd_cgb_zfrzsArr[indexPath.row]}*/
    
    
    _nameL.text = [infoDic objectForKey:@"name"];
    
    NSNumber *pingjia = [infoDic objectForKey:@"gl_zfl"];
    NSNumber *zjd_cgb_zfnhs = [infoDic objectForKey:@"zjd_cgb_zfnhs"];
    NSNumber *zjd_cgb_zfrzs = [infoDic objectForKey:@"zjd_cgb_zfrzs"];
    
    
    _zongpinjiaL.text = [NSString stringWithFormat:@"走访率：%.2f%%  应走%@户，实走%@户",pingjia.floatValue*100,zjd_cgb_zfnhs,zjd_cgb_zfrzs];
    
    
    NSNumber *zfl =  [infoDic objectForKey:@"gl_zfhj"];
    _ZouFangLvL.text = [NSString stringWithFormat:@"%.2f",zfl.floatValue];
    
    NSNumber *bjl =  [infoDic objectForKey:@"gl_zfjcf"];
    _BanJieLv.text = [NSString stringWithFormat:@"%.2f",bjl.floatValue];
    
    NSNumber *myl =  [infoDic objectForKey:@"gl_zffjf"];
    _ManYiDuL.text = [NSString stringWithFormat:@"%.2f",myl.floatValue];
    //画条形图
    UIView *cgbV;
    cgbV = [[UIView alloc] initWithFrame:CGRectMake(_zongpinjiaL.frame.origin.x,_zongpinjiaL.frame.origin.y, _zongpinjiaL.frame.size.width*pingjia.floatValue/100, _zongpinjiaL.frame.size.height)];
    
    cgbV.backgroundColor = [UIColor greenColor];
    [_UpBackView addSubview:cgbV];
    [_UpBackView addSubview:_zongpinjiaL];
    _tCUNNameL.text = [infoDic objectForKey:@"cun_name"];
    [_UpBackView addSubview:_tCUNNameL];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
