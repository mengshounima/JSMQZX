//
//  UserTypeView.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/5.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "UserTypeView.h"
@implementation UserTypeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor =  [UIColor whiteColor];
    //标题
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 50)];
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.text = @"选择用户类型";
    titleL.textColor = [UIColor blueColor];
    [self addSubview:titleL];
    
    float Y = CGRectGetMaxY(titleL.frame);
    _TypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, Y, rect.size.width, rect.size.height-94)];
    _TypeTableView.dataSource = self;
    _TypeTableView.delegate = self;
    [self addSubview:_TypeTableView];
    
    //取消按钮
    Y = CGRectGetMaxY(_TypeTableView.frame);
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, Y, rect.size.width, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
}
//点击取消
-(void)clickCancelBtn:(UIButton *)button{
    [self removeFromSuperview];
    //通知代理
    [self.delegate delegateCancel];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *typedic = _typeARR[indexPath.row];
    [self removeFromSuperview];
    [self.delegate delegateSelectOneType:typedic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"userTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [_typeARR[indexPath.row] objectForKey:@"zjd_name"];
    /*UIImageView *selectImage = [[UIImageView alloc] init];
    selectImage.backgroundColor = [UIColor yellowColor];*/
    if (indexPath.row == 0) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
   
    
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeARR.count;
}
@end
