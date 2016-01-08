//
//  DataCenter.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/22.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USER @"userInfo"
#define ZJD @"zjd"

@interface UserInfo : NSObject
@property (weak,nonatomic) NSString *useType;//所属镇id   SSZ_id
@property (weak,nonatomic) NSString *useID;
@property (strong,nonatomic) NSString *usePassword;
@property (weak,nonatomic) NSNumber *power;//权限
@property (weak,nonatomic) NSString *loginName;//登录编号
@property (weak,nonatomic) NSString *name;//真实姓名
@property (weak,nonatomic) NSString *phone;//联系方式
@property (weak,nonatomic) NSString *administerName;//镇，社区
@property (weak,nonatomic) NSString *sex;
@property (weak,nonatomic) NSString *ismember;//是否党员
@property (weak,nonatomic) NSString *lastLoginTime;
@property (weak,nonatomic) NSString *departmentName;
@property (weak,nonatomic) NSString *post;


//单例模式
//+(UserInfo *)sharedInstance;


@end




//街道列表
@interface ZJDModel : NSObject
@property (weak,nonatomic) NSString *zjd_id;
@property (weak,nonatomic) NSString *zjd_name;
@property (weak,nonatomic) NSString *zjd_jx;
@property (weak,nonatomic) NSString *zjd_sfxs;
//+(ZJDModel *)sharedInstance;
@end


@interface DataCenter : NSObject
+(DataCenter *)sharedInstance;
// 用户信息
@property (strong, nonatomic) UserInfo *UserInfo;
-(void)writeData:(NSDictionary *)resultdic;
-(instancetype)ReadData;

//街道信息
@property (strong, nonatomic) NSArray *zjdArr;

-(void)writeZJDData:(NSArray *)resultArr;
-(instancetype)ReadZJDData;


@end
