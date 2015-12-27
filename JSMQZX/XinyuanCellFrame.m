//
//  XinyuanCellFrame.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "XinyuanCellFrame.h"
#define MJTextFont [UIFont systemFontOfSize:12]
@implementation XinyuanCellFrame
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    MyLog(@"%@",[text class]);
    if (ISNULL(text))
    {
        return CGSizeMake(0, 25);
    }
    else
    {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
}

//计算高度尺寸
- (void)HeightSetMethod
{
    
    //心愿内容
    CGFloat textX = 8;//写死
    CGFloat textY = 20;//写死
    CGSize textSize = [self sizeWithText:self.contentStr font:MJTextFont maxSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT)];
    MyLog(@"*////////////////%f",textSize.height);
    _contentF = CGRectMake(textX, textY, SCREEN_WIDTH-16, textSize.height);
    
    CGFloat Y = CGRectGetMaxY(_contentF);
   
    
    _finisheF = CGRectMake(textX, Y, SCREEN_WIDTH-16, 20);
    _dateF = CGRectMake(textX, Y+20, SCREEN_WIDTH-16, 20);
  
    _cellHeight = CGRectGetMaxY(_dateF);
    MyLog(@"*////////////////%f",_cellHeight);
    
}

@end
