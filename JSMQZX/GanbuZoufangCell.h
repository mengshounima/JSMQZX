//
//  GanbuZoufangCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GanbuZoufangCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *zgbBackView;
@property (weak, nonatomic) IBOutlet UIView *cgbBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *dataZGB;

@property (weak, nonatomic) IBOutlet UILabel *dataCGB;
@property (weak, nonatomic) IBOutlet UILabel *tZGBLabel;
@property (weak, nonatomic) IBOutlet UILabel *tCGBLabel;

-(void)UpdateWithInfoDic:(NSDictionary *)infoDic;
@end
