
//
//  LoginVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/3.
//  Copyright (c) 2015年 liyanqin. All rights reserved.
//

#import "LoginVC.h"
@interface LoginVC ()<UserTypeSelectDelegate,UIGestureRecognizerDelegate,NSXMLParserDelegate>
@property (strong,nonatomic) UIView *backView;
@property (nonatomic,strong)UserTypeView *TypeView;
@property (nonatomic,strong) NSArray *typeArr;
@property (nonatomic,strong) NSDictionary *typeDic;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isLogin = [[USERDEFAULTS objectForKey:@"IsLogin"] boolValue];
    if (isLogin) {
        [self autoLogin];
    }

    [self getUserData];
    [self initView];
}
//自动登录
-(void)autoLogin{
    [MBProgressHUD showMessage:@"登录中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //真实
    /*[param setObject:[_typeDic objectForKey:@"zjd_id"] forKey:@"UserType"];
     [param setObject:_passwordF.text forKey:@"Password"];
     NSString *firstName = [_typeDic objectForKey:@"zjd_jx"];//前缀
     [param setObject:[NSString stringWithFormat:@"%@%@",firstName,_userIDF.text] forKey:@"LoginName"];*/
    _typeF.text = [[UserInfo sharedInstance] ReadData].administerName;
    _userIDF.text = [[UserInfo sharedInstance] ReadData].loginName;
    _passwordF.text = [[UserInfo sharedInstance] ReadData].usePassword;
    //调试
    [param setObject:[[UserInfo sharedInstance] ReadData].useType forKey:@"UserType"];
    [param setObject:[[UserInfo sharedInstance] ReadData].loginName forKey:@"LoginName"];
    [param setObject:[[UserInfo sharedInstance] ReadData].usePassword forKey:@"Password"];
    [[HttpClient httpClient] requestWithPath:@"/CheckLogin" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
       /* NSData* jsonData = [self XMLString:responseObject];
        NSDictionary *resultDic = [jsonData objectFromJSONData];
        MyLog(@"------------------%@",resultDic);
        [[UserInfo sharedInstance] writeData:resultDic];//初始化个人数据
        //保存是否记住密码
        if (_rememberBtn.selected) {
            [USERDEFAULTS setObject:[NSNumber numberWithBool:YES] forKey:@"IsLogin"];
        }*/
        
        //创建导航栏
        HMNavigationController *rootNav;
        UIStoryboard *schoolStoryBoard=[UIStoryboard storyboardWithName:@"Root" bundle:nil];
        rootNav = [schoolStoryBoard instantiateInitialViewController];
        [self presentViewController:rootNav animated:YES completion:nil];
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
    //当前页添加蒙板
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//透明黑色背景
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackView:)];//点击背景取消
    [_backView addGestureRecognizer:tapGes];
    [self.view addSubview:_backView];
    
    
     _TypeView = [[UserTypeView alloc] init];
    _TypeView.typeARR = _typeArr;
    _TypeView.delegate = self;
    _TypeView.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
    [self.view addSubview:_TypeView];
    [UIView animateWithDuration:0.3 animations:^{
        _TypeView.frame = CGRectMake(20, 80, SCREEN_WIDTH-40, SCREEN_HEIGHT-160);
    }];
}

//点击背景
-(void)clickBackView:(UITapGestureRecognizer *)tap
{
    [_TypeView removeFromSuperview];
    [_backView removeFromSuperview];
}
//选择页面的代理方法
-(void)delegateCancel{
    [_backView removeFromSuperview];
}
-(void)delegateSelectOneType:(NSDictionary *)typeDic
{
    [_backView removeFromSuperview];
    _typeDic = typeDic;
    _typeF.text = [typeDic objectForKey:@"zjd_name"];;
    
}
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
       [[UserInfo sharedInstance] writeData:resultDic];//初始化个人数据
        //保存是否记住密码
        if (_rememberBtn.selected) {
            [USERDEFAULTS setObject:[NSNumber numberWithBool:YES] forKey:@"IsLogin"];
        }
       
        //创建导航栏
        HMNavigationController *rootNav;
        UIStoryboard *schoolStoryBoard=[UIStoryboard storyboardWithName:@"Root" bundle:nil];
        rootNav = [schoolStoryBoard instantiateInitialViewController];
        [self presentViewController:rootNav animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}


@end
