
//
//  LoginVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/3.
//  Copyright (c) 2015年 liyanqin. All rights reserved.
//

#import "LoginVC.h"
#import "JKAlertDialog.h"
@interface LoginVC ()<UserTypeSelectDelegate,UIGestureRecognizerDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>{
    JKAlertDialog *alert;
    UITableView *_TypeTable;
}
@property (strong,nonatomic) UIView *backView;
@property (nonatomic,strong)UserTypeView *TypeView;
@property (nonatomic,strong) NSArray *typeArr;
@property (nonatomic,strong) NSDictionary *typeDic;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserData];
    BOOL isLogin = [[USERDEFAULTS objectForKey:@"IsLogin"] boolValue];
    if (isLogin) {
        [self autoLogin];
    }
    [self initView];
}
//自动登录
-(void)autoLogin{
    _loginBtn.enabled = NO;
    [MBProgressHUD showMessage:@"自动登录中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    _typeF.text = [[DataCenter sharedInstance] ReadData].UserInfo.administerName;
    _userIDF.text = [[DataCenter sharedInstance] ReadData].UserInfo.showName;
    _passwordF.text = [[DataCenter sharedInstance] ReadData].UserInfo.usePassword;
    //调试
    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"UserType"];
    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.loginName forKey:@"LoginName"];
    [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.usePassword forKey:@"Password"];
    [[HttpClient httpClient] requestWithPath:@"/CheckLogin" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        MyLog(@"------------------%@",resultDic);
        if (ISNULL(resultDic)) {
       
            [MBProgressHUD showError:@"账号密码不匹配"];
            _loginBtn.enabled = YES;
        }
        else{
            //创建导航栏
            HMNavigationController *rootNav;
            UIStoryboard *schoolStoryBoard=[UIStoryboard storyboardWithName:@"Root" bundle:nil];
            rootNav = [schoolStoryBoard instantiateInitialViewController];
            [self presentViewController:rootNav animated:YES completion:nil];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];

}


-(void)getUserData{
    [MBProgressHUD showMessage:@"更新镇、街道列表"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"1" forKey:@"Type"];
    [param setObject:@"" forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetZJDIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        _typeArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_typeArr);
       [[DataCenter sharedInstance] writeZJDData:_typeArr];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
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
     MyLog(@"***%@",str);
    return  jsonData;
}
-(void)initView{
    _loginBtn.layer.cornerRadius = 6;
    _rememberBtn.selected = YES;//默认选中记住密码
    _passwordF.secureTextEntry = YES;
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, SCREEN_HEIGHT*0.6) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;

}

-(void)changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tapResignFirstResponder];
}
-(void)tapResignFirstResponder
{
    [_userIDF resignFirstResponder];
    [_passwordF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//记住密码
- (IBAction)clickRememberBtn:(id)sender {
    _rememberBtn.selected = !_rememberBtn.selected;
    
}
//用户类型选择
- (IBAction)clickSelectBtn:(id)sender {
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/社区" message:@""];
    alert.contentView =  _TypeTable;
    [alert addButtonWithTitle:@"取消"];
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [alert dismiss];
        _typeDic = _typeArr[indexPath.row];
        _typeF.text = [_typeDic objectForKey:@"zjd_name"];
}
    
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _typeArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *ID = @"ZJDCellQY";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = [_typeArr[indexPath.row] objectForKey:@"zjd_name"];

        return  cell;

}

//**********************************


//登录
- (IBAction)clickLoginBtn:(id)sender {
    if (ISNULLSTR(_userIDF.text)||ISNULLSTR(_typeF.text)||ISNULLSTR(_passwordF.text)) {
        [MBProgressHUD showError:@"登录信息不完整"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //真实
    [param setObject:[_typeDic objectForKey:@"zjd_id"] forKey:@"UserType"];
    [param setObject:_passwordF.text forKey:@"Password"];
    NSString *firstName = [_typeDic objectForKey:@"zjd_jx"];//前缀
    [param setObject:[NSString stringWithFormat:@"%@%@",firstName,_userIDF.text] forKey:@"LoginName"];
    //调试
    /*[param setObject:@"6" forKey:@"UserType"];
    NSString *name = [NSString stringWithFormat:@"%@%@",@"xt",@"1008"];
    [param setObject:name forKey:@"LoginName"];
    [param setObject:@"888888" forKey:@"Password"];*/
    [[HttpClient httpClient] requestWithPath:@"/CheckLogin" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        MyLog(@"------------------%@",resultDic);
        /*
         Type = 6;
         administerCode = 6;
         administerName = "\U897f\U5858\U9547";
         departmentId = "";
         departmentName = "";
         id = 1996;
         ismember = "\U662f";
         lastLoginTime = "2016/1/9 0:00:20";
         loginName = xt1008;
         name = "\U6d4b\U8bd5\Uff08\U6751\Uff09";
         password = 888888;
         phone = "";
         post = "\U6d4b\U8bd5\U8d26\U53f7\Uff08\U6751\Uff09";
         power = 6;
         sex = 1;

         */
        if (ISNULL(resultDic)) {
            [MBProgressHUD showError:@"账号密码不匹配"];
        }
        else{
            //添加自动登录时显示的用户名
            NSMutableDictionary *middledic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
            [middledic setObject:_userIDF.text forKey:@"showName"];
            resultDic = [middledic copy];
            
            [[DataCenter sharedInstance] writeData:resultDic];
            //保存是否记住密码
            if (_rememberBtn.selected) {
                [USERDEFAULTS setObject:[NSNumber numberWithBool:YES] forKey:@"IsLogin"];
            }
            
            //创建导航栏
            HMNavigationController *rootNav;
            UIStoryboard *schoolStoryBoard=[UIStoryboard storyboardWithName:@"Root" bundle:nil];
            rootNav = [schoolStoryBoard instantiateInitialViewController];
            [self presentViewController:rootNav animated:YES completion:nil];
        }
        
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
}


@end
