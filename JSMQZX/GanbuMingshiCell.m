//
//  GanbuMingshiCell.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "GanbuMingshiCell.h"

@implementation GanbuMingshiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)UpdateWithInfoDic:(NSDictionary *)infoDic{
    _titleL.text = [infoDic objectForKey:@"title"];
    NSNumber *ZJDpercent = [infoDic objectForKey:@"ZJDpercent"];
    float ZJDpercentF = ZJDpercent.floatValue*100;
    
    NSNumber *CJDpercent = [infoDic objectForKey:@"CJDpercent"];
    float CJDpercentF = CJDpercent.floatValue*100;
    
    _dataZGB.text = [NSString stringWithFormat:@"%.2f%%(户数%@)",ZJDpercentF,[infoDic objectForKey:@"ZJDZS"]];
    _dataCGB.text = [NSString stringWithFormat:@"%.2f%%(户数%@)",CJDpercentF,[infoDic objectForKey:@"CJDZS"]];
    //画图
    UIView *zgbV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _zgbBackView.frame.size.width*ZJDpercentF/100, _zgbBackView.frame.size.height)];
    zgbV.backgroundColor = [UIColor purpleColor];
    [_zgbBackView addSubview:zgbV];
    [_zgbBackView addSubview:_dataZGB];
    
    
    UIView *cgbV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cgbBackView.frame.size.width*CJDpercentF/100, _cgbBackView.frame.size.height)];
    cgbV.backgroundColor = [UIColor orangeColor];
    [_cgbBackView addSubview:cgbV];
    [_cgbBackView addSubview:_dataCGB];
    
}

@end
