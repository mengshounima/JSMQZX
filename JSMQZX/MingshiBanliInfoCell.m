//
//  MingshiBanliInfoCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/11.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "MingshiBanliInfoCell.h"

@implementation MingshiBanliInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithInfoDic:(NSDictionary *)infoDic{
    MyLog(@"%@",infoDic);
    //NSDictionary *paramDic =  @{@"name":_gl_zsxmArr[indexPath.row],@"gl_zfl":_gl_zflArr[indexPath.row],@"gl_zfjcf":_gl_zfjcfArr[indexPath.row],@"gl_zffjf":_gl_zffjfArr[indexPath.row],@"gl_zfhj":_gl_zfhjArr[indexPath.row]};
    
    
    _nameL.text = [infoDic objectForKey:@"name"];
    
    NSNumber *zjd_cgb_zfnhs = [infoDic objectForKey:@"zjd_cgb_zfnhs"];
    NSNumber *zjd_cgb_zfrzs = [infoDic objectForKey:@"zjd_cgb_zfrzs"];
    NSNumber *pingjia = [infoDic objectForKey:@"gl_zfl"];
    _zongpinjiaL.text = [NSString stringWithFormat:@"办结率：%.2f%%  需办结%@件，已办结%@件",pingjia.floatValue*100,zjd_cgb_zfnhs,zjd_cgb_zfrzs];
    
    
    NSNumber *zfl =  [infoDic objectForKey:@"gl_zfhj"];
    _ZouFangLvL.text = [NSString stringWithFormat:@"%.2f",zfl.floatValue];
    
    NSNumber *bjl =  [infoDic objectForKey:@"gl_zfjcf"];
    _BanJieLv.text = [NSString stringWithFormat:@"%.2f",bjl.floatValue];
    
    NSNumber *myl =  [infoDic objectForKey:@"gl_zffjf"];
    _ManYiDuL.text = [NSString stringWithFormat:@"%.2f",myl.floatValue];
    
    //画条形图
    UIView *cgbV;
    cgbV = [[UIView alloc] initWithFrame:CGRectMake(_zongpinjiaL.frame.origin.x,_zongpinjiaL.frame.origin.y,_zongpinjiaL.frame.size.width*pingjia.floatValue, _zongpinjiaL.frame.size.height)];
     MyLog(@"X:%f   Y:%f  width = %f",cgbV.frame.origin.x,cgbV.frame.origin.y,cgbV.frame.size.width);
    cgbV.backgroundColor = choiceColor(30, 95, 21);
    [_UpBackView addSubview:cgbV];
    [_UpBackView addSubview:_zongpinjiaL];
    _tCUNNameL.text = [infoDic objectForKey:@"cun_name"];
    [_UpBackView addSubview:_tCUNNameL];

    
}

@end
