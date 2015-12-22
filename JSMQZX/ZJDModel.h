//
//  ZJDModel.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJDModel : NSObject
@property (weak,nonatomic) NSString *zjd_id;
@property (weak,nonatomic) NSString *zjd_name;
@property (weak,nonatomic) NSString *zjd_jx;
@property (weak,nonatomic) NSString *zjd_sfxs;
+(ZJDModel *)sharedInstance;
@end
