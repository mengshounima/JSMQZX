//
//  UserInfo.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//
#define USER @"userInfo"
#import "UserInfo.h"

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
    [tempDic setObject:[resultdic objectForKey:@"administerName"] forKey:@"administerName"];
    [tempDic setObject:[resultdic objectForKey:@"power"] forKey:@"power"];
    [tempDic setObject:[resultdic objectForKey:@"id"] forKey:@"id"];
    [tempDic setObject:[resultdic objectForKey:@"name"] forKey:@"name"];
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
    return info;
}
@end
