//
//  UserInfo.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//
#define USER @"userInfo"
#define ZJD @"zjd"
#import "UserInfo.h"
#import "ZJDModel.h"
@implementation UserInfo
+(UserInfo *)sharedInstance{
        static UserInfo *sharedUserInfoInstance = nil;
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            sharedUserInfoInstance = [[self alloc] init];
        });
        return sharedUserInfoInstance;

}
-(void)writeData:(NSDictionary *)resultdic
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:[resultdic objectForKey:@"Type"] forKey:@"Type"];
    [tempDic setObject:[resultdic objectForKey:@"administerName"] forKey:@"administerName"];
    [tempDic setObject:[resultdic objectForKey:@"power"] forKey:@"power"];
    [tempDic setObject:[resultdic objectForKey:@"id"] forKey:@"id"];
    [tempDic setObject:[resultdic objectForKey:@"name"] forKey:@"name"];
    [tempDic setObject:[resultdic objectForKey:@"loginName"] forKey:@"loginName"];
    [tempDic setObject:[resultdic objectForKey:@"departmentName"] forKey:@"departmentName"];
    [tempDic setObject:[resultdic objectForKey:@"phone"] forKey:@"phone"];
    [tempDic setObject:[resultdic objectForKey:@"lastLoginTime"] forKey:@"lastLoginTime"];
    [tempDic setObject:[resultdic objectForKey:@"password"] forKey:@"password"];
    
    [USERDEFAULTS setObject:tempDic forKey:USER];
    [USERDEFAULTS synchronize];
    
}

-(instancetype)ReadData
{
    id valueData = [USERDEFAULTS objectForKey:USER];
    UserInfo *info = [[UserInfo alloc] init];
    info.administerName = [valueData objectForKey:@"administerName"];
    info.power = [valueData objectForKey:@"power"];
    info.useID = [valueData objectForKey:@"id"];
    info.name = [valueData objectForKey:@"name"];
    info.loginName = [valueData objectForKey:@"loginName"];
    info.departmentName = [valueData objectForKey:@"departmentName"];
    info.phone = [valueData objectForKey:@"phone"];
    info.lastLoginTime = [valueData objectForKey:@"lastLoginTime"];
    info.useType = [valueData objectForKey:@"Type"];
    info.usePassword = [valueData objectForKey:@"password"];
    return info;
}


-(void)writeZJDData:(NSDictionary *)resultdic
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:[resultdic objectForKey:@"zjd_id"] forKey:@"zjd_id"];
    [tempDic setObject:[resultdic objectForKey:@"zjd_name"] forKey:@"zjd_name"];
    [tempDic setObject:[resultdic objectForKey:@"zjd_jx"] forKey:@"zjd_jx"];
    [tempDic setObject:[resultdic objectForKey:@"zjd_sfxs"] forKey:@"zjd_sfxs"];
    [USERDEFAULTS setObject:tempDic forKey:ZJD];
    [USERDEFAULTS synchronize];
    
}

-(instancetype)ReadZJDData
{
    id valueData = [USERDEFAULTS objectForKey:ZJD];
    [ZJD init];
    info.administerName = [valueData objectForKey:@"administerName"];
    info.power = [valueData objectForKey:@"power"];
    info.useID = [valueData objectForKey:@"id"];
    return info;
}

@end
