//
//  UserInfo.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (weak,nonatomic) NSString *useType;//所属镇id   SSZ_id
@property (weak,nonatomic) NSString *useID;
@property (weak,nonatomic) NSString *usePassword;
@property (weak,nonatomic) NSString *power;//权限
@property (weak,nonatomic) NSString *loginName;//登录编号
@property (weak,nonatomic) NSString *name;//真实姓名
@property (weak,nonatomic) NSString *phone;//联系方式
@property (weak,nonatomic) NSString *administerName;
@property (weak,nonatomic) NSString *sex;
@property (weak,nonatomic) NSString *ismember;//是否党员
@property (weak,nonatomic) NSString *lastLoginTime;
@property (weak,nonatomic) NSString *departmentName;//镇，社区


//单例模式
+(UserInfo *)sharedInstance;
-(void)writeData:(NSDictionary *)resultdic;
-(instancetype)ReadData;

-(void)writeZJDData:(NSDictionary *)resultdic;
-(instancetype)ReadZJDData;

@end
