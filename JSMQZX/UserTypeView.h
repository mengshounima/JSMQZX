//
//  UserTypeView.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserTypeSelectDelegate<NSObject>
//代理
-(void)delegateSelectOneType:(NSDictionary *)typeDic;
-(void)delegateCancel;

@end
@interface UserTypeView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) NSArray *typeARR;
@property (nonatomic,strong) UITableView *TypeTableView;
@property (nonatomic,weak) id<UserTypeSelectDelegate> delegate;
@end
