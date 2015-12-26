//
//  MJStatusFrame.m
//  04-微博
//
//  Created by apple on 14-4-1.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 正文的字体
#define MJTextFont [UIFont systemFontOfSize:13]

#import "MJStatusFrame.h"
//#import "MJStatus.h"

@implementation MJStatusFrame

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
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
   // _status = status;
    
    // 子控件之间的间距
    //CGFloat padding = 10;
    
    // timeBtn = [[TimeButton alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH, 30)];
    //CGFloat iconX = padding;
    //CGFloat iconY = padding;
  
     //活动内容
    CGFloat textX = 8;//写死
    CGFloat textY = 42;//写死
    CGSize textSize = [self sizeWithText:self.huodongStr font:MJTextFont maxSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT)];
    MyLog(@"*////////////////%f",textSize.height);
    _HuoDongF = CGRectMake(textX, textY, SCREEN_WIDTH-16, textSize.height);
    
    //参加党员
    CGFloat allTimeX = 8;
    CGFloat allTimeY = textSize.height+42;
    CGSize textSize1 = [self sizeWithText:self.dangyuanStr font:MJTextFont maxSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT)];

    _DangYuanF = CGRectMake(allTimeX, allTimeY, SCREEN_WIDTH-16, textSize1.height);
    MyLog(@"*////////*********%f",textSize1.height);
    _cellHeight = 21+21+ textSize.height +textSize1.height;
    MyLog(@"*////////////////%f",_cellHeight);
    
}
@end
