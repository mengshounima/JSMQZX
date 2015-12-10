//
//  SelectFarmerCell.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/11.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFarmerCell : UITableViewCell
-(void)updateCell:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *UpL;
@property (weak, nonatomic) IBOutlet UILabel *downL;
@end
