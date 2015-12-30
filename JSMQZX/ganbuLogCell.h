//
//  ganbuLogCell.h
//  JSMQZX
//
//  Created by aiteyuan on 15/12/30.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ganbuLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *peopleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *yuqiL;
@property (weak, nonatomic) IBOutlet UILabel *leibieL;
@property (weak, nonatomic) IBOutlet UILabel *xvqiuL;
@property (weak, nonatomic) IBOutlet UILabel *banliL;
@property (weak, nonatomic) IBOutlet UILabel *ZJDL;
-(void)updateCell:(NSDictionary *)infoDic;
@end
