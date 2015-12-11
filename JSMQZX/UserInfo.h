//
//  UserInfo.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (weak,nonatomic) NSString *useType;
@property (weak,nonatomic) NSString *useID;
@property (weak,nonatomic) NSString *usePassword;
@property (weak,nonatomic) NSString *power;
@property (weak,nonatomic) NSString *loginName;
@property (weak,nonatomic) NSString *name;
@property (weak,nonatomic) NSString *phone;
@property (weak,nonatomic) NSString *administerName;
@property (weak,nonatomic) NSString *sex;
//单例模式
+(UserInfo *)sharedInstance;
-(void)writeData:(NSDictionary *)resultdic;
-(instancetype)ReadData;
@end
