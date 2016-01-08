//
//  UserInfoTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "UserInfoTableVC.h"
#import "GDataXMLNode.h"
@interface UserInfoTableVC ()

@end

@implementation UserInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    MyLog(@"%@",[[DataCenter sharedInstance] ReadData].UserInfo);
}
#pragma mark
- (void)PasswordViewCancel
{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:0];
        
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
-(void)modify:(UIButton *)button
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0];
        _backView.frame = [UIScreen mainScreen].bounds;
    }
    
    if (_modifyView == nil) {
        _modifyView = [modifyPasswordView modifyPasswordViewMethod];
        _modifyView.delegate = self;
        _modifyView.frame = CGRectMake(0, SCREEN_HEIGHT, 0, 0);
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];//加上第一个蒙版
    [window addSubview:_modifyView];
    [UIView animateWithDuration:0.3 animations:^{
        _modifyView.frame = CGRectMake(0, 0, 0, 0);
        _backView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.5];
    } completion:^(BOOL finished) {
    }];
    
}
- (void)resureAleterPasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    [self editPasswordWith:oldPassword new:newPassword];
}

//修改密码
- (void)editPasswordWith:(NSString *)old new:(NSString *)new
{
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];

    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"Type"];//Type
    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.loginName forKey:@"LoginName"];//LoginName
    [param setObject:old forKey:@"Password"];//旧密码
    [param setObject:new forKey:@"newPassword"];//新密码
    [MBProgressHUD showMessage:@"修改中"];
    
    [[HttpClient httpClient] requestWithPath:@"/ChangePassword" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        [MBProgressHUD hideHUD];
        MyLog(@"------------------%@",resultDic);
        if (ISNULL(resultDic)) {
            
            [MBProgressHUD showError:@"操作失败"];
        }
        else{
            [MBProgressHUD showSuccess:@"修改成功"];
            [[DataCenter sharedInstance] writeData:resultDic];
            }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MyLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}

-(NSData *)XMLString:(NSData *)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data  options:0 error:nil];
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *users = [rootElement children];
    GDataXMLNode  *contentNode = users[0];
    NSString *str =  contentNode.XMLString;
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    return  jsonData;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, 0, SCREEN_WIDTH*0.5, 30)];
    modifyBtn.layer.cornerRadius = 6;
    [modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [modifyBtn setBackgroundColor:[UIColor orangeColor]];
    [modifyBtn addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:modifyBtn];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"UaerInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row ==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"登录编号:%@",[[DataCenter sharedInstance] ReadData].UserInfo.loginName];
    }
    else if (indexPath.row ==1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"真实姓名:%@",[[DataCenter sharedInstance] ReadData].UserInfo.name];
        
        
    }
    else if (indexPath.row ==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"镇、社区:%@",[[DataCenter sharedInstance] ReadData].UserInfo.administerName];
        ;
        
    }
    else if (indexPath.row ==3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"职务:%@",[[DataCenter sharedInstance] ReadData].UserInfo.post];
        ;
        
    }
    else if (indexPath.row ==4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"是否党员:%@",[[DataCenter sharedInstance] ReadData].UserInfo.ismember];
        
    }
    else if (indexPath.row ==5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系方式:%@",[[DataCenter sharedInstance] ReadData].UserInfo.phone];
        
    }

    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"登录时间:%@",[[DataCenter sharedInstance] ReadData].UserInfo.lastLoginTime];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
