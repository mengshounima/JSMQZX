//
//  AddVisitLogVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/8.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "AddVisitLogVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface AddVisitLogVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,BMKLocationServiceDelegate>
{
    UIDatePicker *datePicker;
    UITableView *_CommonTable;
    UITableView *_TypeTable;
    NSArray *commomArr;
    NSArray *typeArr;
    JKAlertDialog *alert;
    UIImage *_myImage;
    NSNumber *flagGaiKuang;
    NSNumber *flagGongXin;
    NSNumber *flagLeiBie;
    NSNumber *flagChuli;
    NSNumber *flagNongHuID;
    int f1;
    int f2;
    BOOL _hasImage;
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
}
@end

@implementation AddVisitLogVC
-(void)viewWillAppear:(BOOL)animated {
    _locService.delegate = self;
     [_locService startUserLocationService];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
     [_locService stopUserLocationService];
}


-(void)PicAddMethod:(NSNotification *)notify{
    //之前已经判断过有图片传过来
    self.ImageArr = notify.object;
    MyLog(@"添加的图片数量%lu",self.ImageArr.count);
    _hasImage = true;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PicAddMethod:) name:@"AddPicFinished" object:nil];
    [self getViewNetData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFarmerFinished:) name:@"selectOneFarmer" object:nil];
    [self initView];
}
-(void)initData{
    flagGaiKuang = 0;
    flagLeiBie = 0;
    flagGongXin = 0;
    flagChuli = 0;
    f1 = 0;
    f2 = 0;
    _hasImage = false;
}
-(void)getViewNetData{
    //获取共性问题list
    [MBProgressHUD showMessage:@"构建页面"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID;
    [param setObject:idStr forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetGXWTType" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f1 = 1;
        if (f1==1&&f2==1) {
            [MBProgressHUD hideHUD];
        }
        NSData* jsonData = [self XMLString:responseObject];
        commomArr = (NSArray *)[jsonData objectFromJSONData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    //获取民生类型
    NSMutableDictionary *paramtype = [[NSMutableDictionary alloc] init];
    [paramtype setObject:idStr forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetMQType" method:TBHttpRequestPost parameters:paramtype prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f2 = 1;
        if (f1==1&&f2==1) {
            [MBProgressHUD hideHUD];
        }

        NSData* jsonData = [self XMLString:responseObject];
        typeArr = (NSArray *)[jsonData objectFromJSONData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
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

-(void)selectFarmerFinished:(NSNotification *)notific{
    NSDictionary *farmerDic = (NSDictionary *)notific.object;
    _farmerF.text = [farmerDic objectForKey:@"user_name"];
    flagNongHuID = [farmerDic objectForKey:@"user_id"];
}
-(void)initView{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    _boxView.layer.cornerRadius = 6;
    _boxView.layer.borderColor = choiceColor(230, 230, 230).CGColor;
    _boxView.layer.borderWidth = 1;
    _sendBtn.layer.cornerRadius = 6;
    //时间选择器
    datePicker = [ [ UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    _dateF.inputView =datePicker;
    //创建工具条
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    toolbar.barTintColor=[UIColor redColor];
    toolbar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel) ];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinish)];
    
    toolbar.items = @[item0, item1, item2];
    //设置文本输入框键盘的辅助视图
    _dateF.inputAccessoryView=toolbar;
    //农户选择,上面添加一个button,透明
    UIButton *FarmerBtn = [[UIButton alloc] initWithFrame:_farmerF.frame];
    FarmerBtn.backgroundColor = [UIColor clearColor];
    [FarmerBtn addTarget:self action:@selector(clickFarmers) forControlEvents:UIControlEventTouchUpInside];
    [_FarmerView addSubview:FarmerBtn];
    //共性
    UIButton *CommonBtn = [[UIButton alloc] initWithFrame:_commonF.frame];
    CommonBtn.backgroundColor = [UIColor clearColor];
    [CommonBtn addTarget:self action:@selector(clickCommon) forControlEvents:UIControlEventTouchUpInside];
    [_CommonView addSubview:CommonBtn];
    //类别
    UIButton *TypeBtn = [[UIButton alloc] initWithFrame:_typeF.frame];
    TypeBtn.backgroundColor = [UIColor clearColor];
    [TypeBtn addTarget:self action:@selector(clickType) forControlEvents:UIControlEventTouchUpInside];
    [_TypeView addSubview:TypeBtn];
    _needTextView.delegate = self;
    _needTextView.returnKeyType = UIReturnKeyDone;
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    _CommonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _CommonTable.delegate = self;
    _CommonTable.dataSource = self;
    
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    

}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_needTextView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
//移除
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectOneFarmer" object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddPicFinished" object:nil];
}
//点击农户
-(void)clickFarmers{
    [self performSegueWithIdentifier:@"AddVisitToFarmerRoot" sender:nil];
    
}
//点击共性
-(void)clickCommon{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择共性问题类型" message:@""];
    alert.contentView =  _CommonTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
}
//点击类别
-(void)clickType{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择民情类别" message:@""];
    alert.contentView =  _TypeTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];

}
#pragma --mark table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_CommonTable) {
        return commomArr.count+1;
    }
    else{
        return typeArr.count+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _CommonTable) {//是否共性
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CommomCell"];
        static NSString *CellIdentifier = @"CommomCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不是共性问题";
        }
        else{
            cell.textLabel.text = [commomArr[indexPath.row-1] objectForKey:@"rdwt_name"];
        }
        return cell;

    }
    else{
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
        static NSString *CellIdentifier = @"typeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"未选择";
        }
        else
        {
            cell.textLabel.text = [typeArr[indexPath.row-1] objectForKey:@"mqlb_name"];
        }
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [alert dismiss];
    if (tableView == _CommonTable) {
        if (indexPath.row==0) {
            //flagGongXin = 2008;
        }
        else{
            flagGongXin = [commomArr[indexPath.row-1] objectForKey:@"rdwt_id"];//用于提交接口参数
            _commonF.text = [commomArr[indexPath.row-1] objectForKey:@"rdwt_name"];

        }
           }
    else{
        if (!indexPath.row==0) {
            flagLeiBie = [typeArr[indexPath.row-1] objectForKey:@"mqlb_id"];//用于提交接口参数
            _typeF.text = [typeArr[indexPath.row-1] objectForKey:@"mqlb_name"];
        }

        
    }
    
}

-(void)clickCancel{
    [_dateF resignFirstResponder];
}
-(void)clickFinish{
    [_dateF resignFirstResponder];
    //选定日期显示
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    _dateF.text = [formatter stringFromDate:datePicker.date];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_dateF resignFirstResponder];
    [_farmerF resignFirstResponder];
    [_needTextView resignFirstResponder];
    [_typeF resignFirstResponder];
    [_commonF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddVisitToFarmerRoot"]) {
         FarmersVC *farmers = segue.destinationViewController;
    }
    else if([segue.identifier isEqualToString:@"AddLogToPicVC"]){
        PicViewController *picVC = segue.destinationViewController;
    }

}

//提交日志
- (IBAction)clickSendBtn:(id)sender {
    [self uploadImages2:@"2015-12-25 19:45:45"];
    /*if (ISNULL(_userLocation)) {
        [MBProgressHUD showError:@"尚未定位成功，请稍等再试"];
        return;
    }
    if (ISNULLSTR(_dateF.text)||ISNULLSTR(_farmerF.text)||flagGaiKuang==0||flagChuli==0) {
        [MBProgressHUD showError:@"内容未填写完整"];
        return;
    }
    [MBProgressHUD showMessage:@"提交中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:_dateF.text forKey:@"rz_zfrq"];//日期***必填
    [param setObject:flagNongHuID forKey:@"rz_zfnh"];//农户id***必填

    [param setObject:flagGaiKuang forKey:@"rz_mqgk"];//民情概况int1234***必填
    
    [param setObject:flagLeiBie forKey:@"rz_mqlb"];//类别id***有初始化为0
    
    if (ISNULLSTR(_needTextView.text)) {
         [param setObject:@"" forKey:@"rz_msxq"];//需求，文本*****非必填
    }
    else{
         [param setObject:_needTextView.text forKey:@"rz_msxq"];//需求，文本*****非必填
    }
    
    
    [param setObject:flagChuli forKey:@"rz_ztxx"];//状态信息（处理结果）****非必填有初始化
    [param setObject:@"2" forKey:@"rz_xxlb"];//日志信息类别 1为固定走访的，2为非固定走访的
    [param setObject:flagGongXin forKey:@"rz_sfgx"];//共性问题类别id****非必填有初始化
    
    //最近办理时间，添加日志时。填现在时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *currentStr = [formatter stringFromDate:[NSDate date]];
    
    [param setObject:currentStr forKey:@"rz_zjblsj"];//日志最终办理结果的时间
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.longitude] forKey:@"placeLongitude"];//经纬度
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.latitude] forKey:@"placeLatitude"];
    [[HttpClient httpClient] requestWithPath:@"/CreateMQLogRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSString *resultID  =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!ISNULLSTR(resultID)) {
            //[MBProgressHUD showSuccess:@"日志提交成功"];
            MyLog(@"创建的日志id:%@",resultID);
            //若有照片则传照片
            if (_hasImage) {
                [self uploadImages1:resultID];
            }
        }
        else{
            [MBProgressHUD showError:@"日志提交失败，请重试"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];*/
    
}
-(void)uploadImages1:(NSString *)RiZiID{
    //传文件名，得到picID
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *date = [formatter stringFromDate:[NSDate date] ];

    NSMutableDictionary *paramPic = [[NSMutableDictionary alloc] init];
    [paramPic setObject:[[DataCenter sharedInstance] ReadData ].UserInfo.useID  forKey:@"userId"];
    [paramPic setObject:RiZiID forKey:@"rz_id"];
    [paramPic setObject:date forKey:@"photoCode"];
    [paramPic setObject:date forKey:@"takeDate"];
    [[HttpClient httpClient] requestWithPath:@"/CreateMQPhoto" method:TBHttpRequestPost parameters:paramPic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        NSData* jsonData = [self XMLString:responseObject];
        NSString *PicID  =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (!ISNULLSTR(PicID)) {
            //开始上传图片数据
            [self uploadImages2:PicID];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];

    
    
  }
-(void)uploadImages2:(NSString *)PicID
{
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    [param setObject:@"2015-12-25 19:45:45" forKey:@"filename"];
    [MBProgressHUD showMessage:@"上传中"];
    NSInteger count = self.ImageArr.count;
    //多张图片上传
    [[HttpClient httpClient] requestOperaionManageWithURl:@"http://122.225.44.14:802/save.aspx" httpMethod:TBHttpRequestPost parameters:param bodyData:self.ImageArr DataNumber:count success:^(AFHTTPRequestOperation *operation, id response) {
        
       
        NSInteger resultStatusCode = [operation.response statusCode];
         MyLog(@"result-----------------------------:%d",resultStatusCode);
        [MBProgressHUD hideHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"错误i*/*******%@",error);
        [MBProgressHUD hideHUD];
    }];
    

}

- (IBAction)clickPicBtn:(id)sender {
    [self performSegueWithIdentifier:@"AddLogToPicVC" sender:nil];
    
}

- (IBAction)clickbtn1:(id)sender {
    flagGaiKuang = [NSNumber numberWithInt:1];
    _btn1.selected = YES;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = NO;
}

- (IBAction)clickbtn3:(id)sender {
    flagGaiKuang = [NSNumber numberWithInt:3];
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = YES;
    _btn4.selected = NO;
}

- (IBAction)clickbtn2:(id)sender {
    flagGaiKuang = [NSNumber numberWithInt:2];
    _btn1.selected = NO;
    _btn2.selected = YES;
    _btn3.selected = NO;
    _btn4.selected = NO;

}

- (IBAction)clickbtn4:(id)sender {
    flagGaiKuang = [NSNumber numberWithInt:4];
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = YES;
}
- (IBAction)clickbutton1:(id)sender {
    flagChuli = [NSNumber numberWithInt:1];
    _button1.selected = YES;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
}

- (IBAction)clickbutton2:(id)sender {
    flagChuli = [NSNumber numberWithInt:2];
    _button1.selected = NO;
    _button2.selected = YES;
    _button3.selected = NO;
    _button4.selected = NO;
}
- (IBAction)clickbutton4:(id)sender {
    flagChuli = [NSNumber numberWithInt:4];
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = YES;
}

- (IBAction)clickbutton3:(id)sender {
    flagChuli = [NSNumber numberWithInt:3];
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = YES;
    _button4.selected = NO;
}


@end
