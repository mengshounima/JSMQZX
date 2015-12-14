//
//  LogCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/14.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GKImageView;
-(void)updateContent:(NSDictionary *)infoDic;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *ZFGBLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *BanliZTLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *NeedLabel;

@end
