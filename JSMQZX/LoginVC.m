
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
    [self getUserData];
    BOOL isLogin = [[USERDEFAULTS objectForKey:@"IsLogin"] boolValue];
    if (isLogin) {
        [self autoLogin];
    }
    
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
/*
-(void)getUserData{
    NSString *BaseURLString = @"http://122.225.44.14:802/webapi.asmx/GetZJDIndex";
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"json" forKey:@"format"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"text/html"];
    [client postPath:@"weather.php" parameters:parameters success:^(AFHTTPRequestOperation*operation, id responseObject) {
        NSString* newStr = [[NSString alloc] initWithData:responseObjectencoding:NSUTF8StringEncoding];
        NSLog(@"POST请求:%@",newStr);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [client getPath:@"weather.php" parameters:parameters success:^(AFHTTPRequestOperation*operation, id responseObject) {
        NSString* newStr = [[NSString alloc] initWithData:responseObjectencoding:NSUTF8StringEncoding];
        NSLog(@"GET请求：%@",newStr);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}*/

-(void)getUserData{
    //[MBProgressHUD showMessage:@"更新镇、街道列表"];
    [MBProgressHUD showMessage:@"更新镇、街道列表" toView:self.view];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"1" forKey:@"Type"];
    [param setObject:@"" forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetZJDIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
         MyLog(@"---**--%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSXMLParser *parser = (NSXMLParser *)responseObject;
         //这里使用了第三方框架 XMLDictionary，他本身继承并实现 NSXMLParserDelegate 委托代理协议，对数据进行遍历处理
        //[self convertXMLParserToDictionary:parser];
        
        NSData* jsonData = [self XMLString:responseObject];
        _typeArr = [jsonData objectFromJSONData];
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        MyLog(@"***%@",error);
    }];

}
- (void)convertXMLParserToDictionary:(NSXMLParser *)parser {
         //dictionaryWithXMLParser: 是第三方框架 XMLDictionary 的方法
        NSDictionary *dic = [NSDictionary dictionaryWithXMLParser:parser];
         NSMutableString *mStrWeatherInfo = [[NSMutableString alloc] initWithString:@"广州近三天天气情况：\n"];
         NSArray *arrWeatherInfo = [dic objectForKey:@"string"];
         if (arrWeatherInfo != nil && arrWeatherInfo.count > 22) {
                 NSMutableArray *mArrRange = [[NSMutableArray alloc] init];
        
                 NSUInteger loc = mStrWeatherInfo.length;
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[6]];
                 NSUInteger len = mStrWeatherInfo.length - loc;
                 NSValue *valObj = [NSValue valueWithRange:NSMakeRange(loc, len)];
                 [mArrRange addObject:valObj];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[5]];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[7]];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[10]];
        
                 loc = mStrWeatherInfo.length;
                 [mStrWeatherInfo appendFormat:@"\n\n %@", arrWeatherInfo[13]];
                 len = mStrWeatherInfo.length - loc;
                 valObj = [NSValue valueWithRange:NSMakeRange(loc, len)];
                 [mArrRange addObject:valObj];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[12]];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[14]];
        
                 loc = mStrWeatherInfo.length;
                 [mStrWeatherInfo appendFormat:@"\n\n %@", arrWeatherInfo[18]];
                 len = mStrWeatherInfo.length - loc;
                 valObj = [NSValue valueWithRange:NSMakeRange(loc, len)];
                 [mArrRange addObject:valObj];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[17]];
                 [mStrWeatherInfo appendFormat:@"\n %@", arrWeatherInfo[19]];
        
                 [mStrWeatherInfo appendFormat:@"\n\n %@", arrWeatherInfo[22]];
        
                 //数据的前10个字符以16.0像素加粗显示；这里使用 UITextView 的 attributedText，而他的 text 无法实现这种需求
                 NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:mStrWeatherInfo];
                 [mAttrStr addAttribute:NSFontAttributeName
                                              value:[UIFont boldSystemFontOfSize:16.0]
                                              range:NSMakeRange(0, 10)];
        
                 //数据的日期部分以紫色显示
                 for (NSValue *valObj in mArrRange) {
                         NSRange currentRange;
                         [valObj getValue:&currentRange];
                         [mAttrStr addAttribute:NSForegroundColorAttributeName
                                                          value:[UIColor purpleColor]
                                                          range:currentRange];
                     }
        
                 //数据的前10个字符之后的内容全部以15.0像素显示
                 [mAttrStr addAttribute:NSFontAttributeName
                                              value:[UIFont systemFontOfSize:15.0]
                                              range:NSMakeRange(10, mStrWeatherInfo.length - 10)];
             
                 //_txtVResult.attributedText = mAttrStr;
             } else {
                     //_txtVResult.text = @"请求数据无效";
                 }
    
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
