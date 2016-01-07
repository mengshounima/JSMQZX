//
//  ModifyLogVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ModifyLogVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MyPicVC.h"
@interface ModifyLogVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,BMKLocationServiceDelegate>
{
   NSDictionary  *LogDic;
    NSInteger f1;//共性
    NSInteger f2;//类别
    NSInteger f3;//日志详情
    NSInteger f4;//照片列表
    NSArray *imageArr;
    NSArray *commomArr;
    NSArray *typeArr;
    NSNumber *flagGaiKuang;
    NSNumber *flagGongXin;
    NSNumber *flagLeiBie;
    NSNumber *flagChuli;
    NSNumber *flagNongHuID;
    UIDatePicker *datePicker;
    UITableView *_CommonTable;
    UITableView *_TypeTable;
    JKAlertDialog *alert;
    BOOL _hasImage;
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
     NSMutableArray *imageNameArr;
    int flaghttp;
}
@property (nonatomic,strong) NSMutableArray *ImageDataArr;

@end

@implementation ModifyLogVC
-(void)viewWillAppear:(BOOL)animated {
    if (_hasImage) {
        [_picBtn setImage:[UIImage imageNamed:@"照片"] forState:UIControlStateNormal];
    }
    else{
        [_picBtn setImage:[UIImage imageNamed:@"相机蓝色"] forState:UIControlStateNormal];
    }
    _locService.delegate = self;
    [_locService startUserLocationService];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
    [_locService stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PicAddMethod:) name:@"AddPicFinished" object:nil];
    [self initData];
    [self getViewNetData];//构建页面
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)PicAddMethod:(NSNotification *)notify{
    [_picBtn setImage:[UIImage imageNamed:@"照片"] forState:UIControlStateNormal];
    imageArr = notify.object;
    MyLog(@"添加的图片数量%lu",(unsigned long)imageArr.count);
    _hasImage = true;
    //将传过来的image转为data数组
    NSMutableArray *imageArrMut = [[NSMutableArray alloc] init];
    for (UIImage *image in imageArr) {
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        [imageArrMut addObject:data];
    }
    self.ImageDataArr = [imageArrMut copy];
    //之前已经判断过有图片传过来
}

-(void)initData{
  
    f1 = 0;
    f2 = 0;
    f3 = 0;
    f4 = 0;
}
-(void)initView{
    _boxView.layer.cornerRadius = 6;
    _boxView.layer.borderColor = choiceColor(230, 230, 230).CGColor;
    _boxView.layer.borderWidth = 1;
    _sendBtn.layer.cornerRadius = 6;
    _farmerF.enabled = NO;//农户姓名不允许修改
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
    
    
    _CommonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 230) style:UITableViewStylePlain];
    _CommonTable.delegate = self;
    _CommonTable.dataSource = self;
    
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.8) style:UITableViewStylePlain];
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
//点击图片按钮
- (IBAction)clickPicBtn:(id)sender{
    if (_hasImage) {
        _hasImage = false;
        //有图片
        MyPicVC *mypicVC = [[MyPicVC alloc] init];
        mypicVC.RZ_imageArr = imageArr;
        [self.navigationController pushViewController:mypicVC animated:YES];
    }
    else{
        MyPicVC *mypicVC = [[MyPicVC alloc] init];
        [self.navigationController pushViewController:mypicVC animated:YES];
    }

   
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
        if (indexPath.row!=0) {
            
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

-(void)getViewNetData{
    //获取共性问题list
    [MBProgressHUD showMessage:@"构建页面"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetGXWTType" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f1 = 1;
        if (f1==1&&f2==1&&f3==1&f4==1) {
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
        if (f1==1&&f2==1&&f3==1&f4==1) {
            [MBProgressHUD hideHUD];
        
        }
        
        NSData* jsonData = [self XMLString:responseObject];
        typeArr = (NSArray *)[jsonData objectFromJSONData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    //获取日志详情
    NSMutableDictionary *paramDetail = [[NSMutableDictionary alloc] init];
    [paramDetail setObject:idStr forKey:@"userId"];
    [paramDetail setObject:[_myLogInfo objectForKey:@"rz_id"] forKey:@"rz_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfoByID" method:TBHttpRequestPost parameters:paramDetail prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f3=1;
        if (f1==1&&f2==1&&f3==1&f4==1) {
            [MBProgressHUD hideHUD];
           
        }
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *arr = (NSArray *)[jsonData objectFromJSONData];
        LogDic = arr[0];
        MyLog(@"%@",LogDic);//日志详情
        [self UpdateView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    //获取图片集合
    NSMutableDictionary *paramImage = [[NSMutableDictionary alloc] init];
    [paramImage setObject:idStr forKey:@"userId"];
    [paramImage setObject:[_myLogInfo objectForKey:@"rz_id"] forKey:@"rz_id"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetMQPhotosRzID" method:TBHttpRequestPost parameters:paramDetail prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f4=1;
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *resultArr = (NSArray *)[jsonData objectFromJSONData];
        if (resultArr.count>0) {
            _hasImage = YES;
            if (_hasImage) {
                [_picBtn setImage:[UIImage imageNamed:@"照片"] forState:UIControlStateNormal];
            }
            else{
                [_picBtn setImage:[UIImage imageNamed:@"相机蓝色"] forState:UIControlStateNormal];
            }

            //图片加载
            NSMutableArray *middleArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic  in resultArr) {
                NSString *urlStr = [dic objectForKey:@"photoUrl"];
                NSString *allURL = [NSString stringWithFormat:@"http://122.225.44.14:802/ClientPhoto/%@",urlStr];
                
                NSURL *URL = [NSURL URLWithString:allURL];
                MyLog(@"--------%@",allURL);
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                //***
                [manager downloadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    NSLog(@"显示当前进度");
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (!ISNULL(image)) {
                        [middleArr addObject:image];
                        if (!ISNULL(middleArr)) {
                            imageArr = [middleArr mutableCopy];
                            
                        }
                    }
                    
                    NSLog(@"下载完成");
                    
                }];

                ///**
                
               /* [manager downloadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                NSLog(@"显示当前进度");
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (!ISNULL(image)) {
                        [middleArr addObject:image];
                    }
                    
                    NSLog(@"下载完成");
                    
                }];*/
                
            }
            if (!ISNULL(middleArr)) {
                imageArr = [middleArr copy];
                //将网上得到的image转为data数组
                NSMutableArray *imageArrMut = [[NSMutableArray alloc] init];
                for (UIImage *image in imageArr) {
                    NSData *data;
                    data = UIImageJPEGRepresentation(image, 0.5);
                    [imageArrMut addObject:data];
                }
                self.ImageDataArr = [imageArrMut copy];
                
            }
            //有图
            if (f1==1&&f2==1&&f3==1&f4==1) {
                [MBProgressHUD hideHUD];
               
            }
            
        }
        else{
            //无图
            _hasImage = NO;
            if (f1==1&&f2==1&&f3==1&f4==1) {
                [MBProgressHUD hideHUD];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];


}

-(void)UpdateView{
    _dateF.text = [LogDic objectForKey:@"rz_zfrq"];
    _farmerF.text = [LogDic objectForKey:@"rz_zfnh_name"];
    NSNumber *mqgk = [LogDic objectForKey:@"rz_mqgk"];
    if (mqgk.integerValue==1) {
        _btn1.selected = YES;
    } else if(mqgk.integerValue==2){
        _btn2.selected = YES;
    }
    else if(mqgk.integerValue==3){
        _btn3.selected = YES;
    }
    else{
        _btn4.selected = YES;
    }
    NSNumber *sfgx = [LogDic objectForKey:@"rz_sfgx"];
    for (NSDictionary *dic in commomArr) {
        NSNumber *rdwt_id = [dic objectForKey:@"rdwt_id"];
        if (sfgx.integerValue == rdwt_id.integerValue) {
            _commonF.text = [dic objectForKey:@"rdwt_name"];
        }
    }
    NSNumber *mqlb = [LogDic objectForKey:@"rz_mqlb"];
    for (NSDictionary *dic in typeArr) {
        NSNumber *mqlb_id = [dic objectForKey:@"mqlb_id"];
        if (mqlb.integerValue == mqlb_id.integerValue) {
            _typeF.text = [dic objectForKey:@"mqlb_name"];
        }
    }
    _needTextView.text = [LogDic objectForKey:@"rz_msxq"];
    NSNumber *ztxx = [LogDic objectForKey:@"rz_ztxx"];
    if (ztxx.integerValue == 1) {
        _button3.selected = YES;
    }
    else if (ztxx.integerValue == 2) {
        _button2.selected = YES;
    }
    else if (ztxx.integerValue == 3) {
        _button4.selected = YES;
    }
    else{
        _button1.selected = YES;
    }
    //旧的日志信息
    flagGaiKuang = [LogDic objectForKey:@"rz_mqgk"];
    flagChuli = [LogDic objectForKey:@"rz_ztxx"];
    flagGongXin = [LogDic objectForKey:@"rz_sfgx"];
    flagLeiBie = [LogDic objectForKey:@"rz_mqlb"];
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
//修改日志
- (IBAction)clickSendBtn:(id)sender{
    [MBProgressHUD showMessage:@"修改中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID;
    [param setObject:idStr forKey:@"userId"];
     [param setObject:[_myLogInfo objectForKey:@"rz_id"] forKey:@"rz_id"];//修改的日志id
    [param setObject:_dateF.text forKey:@"rz_zfrq"];//日期***必填
    [param setObject:[_myLogInfo objectForKey:@"rz_zfnh"] forKey:@"rz_zfnh"];//农户id***必填
    
    [param setObject:flagGaiKuang forKey:@"rz_mqgk"];//民情概况int1234***必填
    
    if (ISNULL(flagLeiBie)) {
        [param setObject: @"" forKey:@"rz_mqlb"];//类别id
    }
    else{
        [param setObject:flagLeiBie forKey:@"rz_mqlb"];//类别id***
    }
    
    
    if (ISNULLSTR(_needTextView.text)) {
        [param setObject:@"" forKey:@"rz_msxq"];//需求，文本*
    }
    else{
        [param setObject:_needTextView.text forKey:@"rz_msxq"];//需求，文本*****非必填
    }
    
    [param setObject:flagChuli forKey:@"rz_ztxx"];//状态信息（处理结果）****非必填有初始化
    
    //随机走访，非固定
    [param setObject:@"2" forKey:@"rz_xxlb"];//日志信息类别 1为固定走访的，2为非固定走访的
    
    if (ISNULL(flagGongXin)) {
        [param setObject:@"" forKey:@"rz_sfgx"];//共性问题类别id****非必填
    }
    else{
        [param setObject:flagGongXin forKey:@"rz_sfgx"];//共性问题类别id****非必填
    }
    
    //最近办理时间，添加日志时。填现在时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *currentStr = [formatter stringFromDate:[NSDate date]];
    
    [param setObject:currentStr forKey:@"rz_zjblsj"];//日志最终办理结果的时间
    [param setObject:[_myLogInfo objectForKey:@"placeLongitude"] forKey:@"placeLongitude"];//经纬度
    [param setObject:[_myLogInfo objectForKey:@"placeLatitude"]  forKey:@"placeLatitude"];
    [[HttpClient httpClient] requestWithPath:@"/EditMQLogRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //[MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSString *resultID  =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (![resultID isEqualToString:@"-1"]) {
            MyLog(@"创建的日志id:%@",resultID);
            //若有照片则传照片
            if (_hasImage) {
                [self uploadImages1:resultID];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"提交成功"];
            }
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"日志提交失败，请重试1"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];

}

-(void)uploadImages1:(NSString *)RiZiID{
     flaghttp = 0;
    for (int i = 0; i<self.ImageDataArr.count; i++) {
        //传文件名，得到picID
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *date = [formatter stringFromDate:[NSDate date] ];
        NSDate *nowDate = [NSDate date] ;
        NSTimeInterval timeStamp= [nowDate timeIntervalSince1970];//当前日期转化为毫秒数
        NSTimeInterval timeStampIN = timeStamp*1000000;
        NSMutableDictionary *paramPic = [[NSMutableDictionary alloc] init];
        [paramPic setObject:[[DataCenter sharedInstance] ReadData ].UserInfo.useID  forKey:@"userId"];
        [paramPic setObject:RiZiID forKey:@"rz_id"];
        
        [paramPic setObject:[NSString stringWithFormat:@"%lld-%d",(long long)timeStampIN,i] forKey:@"photoCode"];//为了唯一性，毫秒数添加i        [paramPic setObject:date forKey:@"takeDate"];
        [[HttpClient httpClient] requestWithPath:@"/CreateMQPhoto" method:TBHttpRequestPost parameters:paramPic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            flaghttp ++;
           
            NSData* jsonData = [self XMLString:responseObject];
            NSString *PicID  =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            MyLog(@"创建的图片id:%@",PicID);
            if (![PicID isEqualToString:@"-1"]) {
                [imageNameArr addObject:PicID];
                
                if (flaghttp==self.ImageDataArr.count)  {
                    //开始上传图片数据
                    NSArray *imageName = [imageNameArr copy];
                    MyLog(@"最后一次添加后imageNameArr.count%d",imageName.count);
                    [self uploadImages2:imageName];//传图片id
                }
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"图片上传失败，请重试2"];
                return ;//退出循环
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求失败"];
            return ;//退出循环
        }];
        
        
    }
    
    
    
}
-(void)uploadImages2:(NSArray *)imageNameARR
{
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    //此param不传到服务器，但传入函数作为图片指定名称
    
    MyLog(@"/////////////////////////////创建的图片名称:%@",imageNameARR);
    
    NSInteger count = self.ImageDataArr.count;
    flaghttp = 0;
    for (int i = 0; i<count; i++) {
        [param setObject:imageNameARR[i] forKey:@"filename"];//传入多张图片名数组
        //多张图片上传
        [[HttpClient httpClient] requestOperaionManageWithURl:@"http://122.225.44.14:802/save.aspx" httpMethod:TBHttpRequestPost parameters:param bodyData:self.ImageDataArr[i] DataNumber:count success:^(AFHTTPRequestOperation *operation, id response) {
            flaghttp++;
            NSInteger resultStatusCode = [operation.response statusCode];
            MyLog(@"result-----------------------------:%d",resultStatusCode);
            if (resultStatusCode==200) {
                if (flaghttp==count) {
                    //所有图片都已上传
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"提交成功"];
                    //跳出该控制器
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"图片上传失败，请重试3"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MyLog(@"错误i*/*******%@",error);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求失败"];
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)clickLocationBtn:(id)sender {
    GanbuLocationVC *locationVc = [[GanbuLocationVC alloc] init];
    locationVc.infoDic = LogDic;
    [self.navigationController pushViewController:locationVc animated:YES];
    
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
