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
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "LogConfirmView.h"
@interface AddVisitLogVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,BMKLocationServiceDelegate,LogConfirmDelegate,BMKGeoCodeSearchDelegate>
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
    NSMutableArray *imageNameArr;
    int flaghttp;
    NSString *locationStr;
}
// 蒙版
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) LogConfirmView *conFirmView;
@property (nonatomic,strong) BMKGeoCodeSearch *searcher;
@end

@implementation AddVisitLogVC
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

//通知有照片拍得
-(void)PicAddMethod:(NSNotification *)notify{
    [_picBtn setImage:[UIImage imageNamed:@"照片"] forState:UIControlStateNormal];
    self.ImageArr = notify.object ;
    MyLog(@"添加的图片数量%lu",(unsigned long)self.ImageArr.count);
    _hasImage = true;
    //将传过来的uiimage转为data数组
    NSMutableArray *imageArrMut = [[NSMutableArray alloc] init];
    for (UIImage *image in self.ImageArr) {
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        [imageArrMut addObject:data];
    }
   self.ImageDataArr = [imageArrMut copy];
    //之前已经判断过有图片传过来
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
    _commonF.text = @"不是共性问题";
    _typeF.text = @"未选择";
    imageNameArr = [[NSMutableArray alloc] init];
    f1 = 0;
    f2 = 0;
    _hasImage = false;
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
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
    if (_FlagSuiji.boolValue) {
        _farmerF.enabled = NO;//若是选择农户new的控制器，则农户不允许选择
    }
    if (!ISNULL(_farmerInfo)) {
        _farmerF.text = [_farmerInfo objectForKey:@"user_name"];
        flagNongHuID = [_farmerInfo objectForKey:@"user_id"];
    }
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
    toolbar.barTintColor=choiceColor(123, 0, 15);
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
    _needTextView.layer.cornerRadius = 5;
    _needTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    _needTextView.layer.borderWidth=1;
    _needTextView.delegate = self;
    _needTextView.returnKeyType = UIReturnKeyDone;
    
    _CommonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _CommonTable.delegate = self;
    _CommonTable.dataSource = self;
    
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.8) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    

}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption =[[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSString *addressStr =result.address;
      NSString *name;
      if ([result.poiList count]>0) {
          BMKPoiInfo *poiInfo = result.poiList[0];
          name = poiInfo.name;
      }
      else{
          name = result.addressDetail.streetName;
      }
      if (!ISNULLSTR(name)) {
          locationStr = [NSString stringWithFormat:@"%@%@",addressStr,name];
      }
      else{
          locationStr = addressStr;
      }
      
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
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
    BOOL flag = YES;
    [self performSegueWithIdentifier:@"AddVisitToFarmerRoot" sender:[NSNumber numberWithBool:flag]];
    
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
        if (indexPath.row==0)
        {
            flagGongXin = nil;
            _commonF.text = @"不是共性问题";

           }
        else{
            
            flagGongXin = [commomArr[indexPath.row-1] objectForKey:@"rdwt_id"];//用于提交接口参数
            _commonF.text = [commomArr[indexPath.row-1] objectForKey:@"rdwt_name"];
        }
        
    }
    else{
        if (indexPath.row==0) {
            flagLeiBie = nil;
            _typeF.text = @"未选择";
        }
        else{
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
        farmers.FlagSuiji = sender;
    }
}
//代理提交方法
-(void)clickSend{
    
    [MBProgressHUD showMessage:@"提交中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:_dateF.text forKey:@"rz_zfrq"];//日期***必填
    [param setObject:flagNongHuID forKey:@"rz_zfnh"];//农户id***必填
    
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
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.longitude] forKey:@"placeLongitude"];//经纬度
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.latitude] forKey:@"placeLatitude"];
    [[HttpClient httpClient] requestWithPath:@"/CreateMQLogRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                [MBProgressHUD showSuccess:@"日志提交成功"];
                //跳出该控制器
                [self.navigationController popViewControllerAnimated:YES];
                
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
//代理取消方法
-(void)clickCanceled{
    [UIView animateWithDuration:0.2 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:0];
        
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];

}
//提交日志
- (IBAction)clickSendBtn:(id)sender {
    if (ISNULL(_userLocation)) {
        [MBProgressHUD showError:@"尚未定位成功，请稍后再试"];
        return;
    }
    if (ISNULLSTR(_dateF.text)||ISNULLSTR(_farmerF.text)||ISNULL(flagGaiKuang)||ISNULL(flagChuli)) {
        [MBProgressHUD showError:@"内容未填写完整"];
        return;
    }
    
    
    
    //弹框，确认提交日志
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = [UIScreen mainScreen].bounds;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (_conFirmView == nil) {
        _conFirmView = [[LogConfirmView alloc] init];
        
       
        [dic setObject:_dateF.text forKey:@"date"]; //走访日期
        [dic setObject:_farmerF.text forKey:@"zfnh_name"];//走访农户
        if (flagGaiKuang.integerValue==1) {//概况
            [dic setObject: @"晴天"forKey:@"mqgk"];
        }
        else if (flagGaiKuang.integerValue==2) {
            [dic setObject: @"多云" forKey:@"mqgk"];
        }
        else if (flagGaiKuang.integerValue==3) {
            [dic setObject:@"阴天" forKey:@"mqgk"];
        }
        else {
            [dic setObject:@"下雨" forKey:@"mqgk"];
        }
        
        [dic setObject:_commonF.text forKey:@"sfgx"];//共性
        [dic setObject:_typeF.text forKey:@"leibie"];//类别
        [dic setObject:_needTextView.text forKey:@"need"];//需求
        
        if (flagChuli.integerValue==1) {//结果
            [dic setObject: @"无诉求"forKey:@"ztxx"];
        }
        else if (flagChuli.integerValue==2) {
            [dic setObject: @"当场办结（答复）" forKey:@"ztxx"];
        }
        else if (flagChuli.integerValue==3) {
            [dic setObject:@"正在办理" forKey:@"ztxx"];
        }
        else {
            [dic setObject:@"提交上一级党委政府研究" forKey:@"ztxx"];
        }
        [dic setObject:[[DataCenter sharedInstance] ReadData].UserInfo.name forKey:@"zfr"];//走访人
        [dic setObject:[NSNumber numberWithInt:self.ImageArr.count] forKey:@"picsNumber"];//照片

        [dic setObject:locationStr forKey:@"Location"];//地址
        
       
        _conFirmView.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_backView];//加上第一个蒙版
        [window addSubview:_conFirmView];
            _conFirmView.frame = CGRectMake(20, 60, SCREEN_WIDTH-40, SCREEN_HEIGHT-120);//size设定
            [_conFirmView updateView:dic];
            _backView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.5];
   

    }
    
}

-(void)uploadImages1:(NSString *)RiZiID{
    flaghttp = 0;
    for (int i = 0; i<self.ImageDataArr.count; i++) {
        //传文件名，得到picID
        MyLog(@"------------------------------i:%d",i);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *date = [formatter stringFromDate:[NSDate date] ];
        
        NSDate *nowDate = [NSDate date] ;
        NSTimeInterval timeStamp= [nowDate timeIntervalSince1970];//当前日期转化为毫秒数,用作图片名称
        NSTimeInterval timeStampIN = timeStamp*1000000;
        NSMutableDictionary *paramPic = [[NSMutableDictionary alloc] init];
        [paramPic setObject:[[DataCenter sharedInstance] ReadData ].UserInfo.useID  forKey:@"userId"];
        [paramPic setObject:RiZiID forKey:@"rz_id"];
        
        [paramPic setObject:[NSString stringWithFormat:@"%lld-%d",(long long)timeStampIN,i] forKey:@"photoCode"];//为了唯一性，毫秒数添加i

        [paramPic setObject:date forKey:@"takeDate"];
        [[HttpClient httpClient] requestWithPath:@"/CreateMQPhoto" method:TBHttpRequestPost parameters:paramPic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            flaghttp ++;
                NSData* jsonData = [self XMLString:responseObject];
                NSString *PicID  =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                MyLog(@"/////////////////////////////PicID:%@",PicID);
                MyLog(@"/////////////////////////////self.ImageDataArr.count:%lu",(unsigned long)self.ImageDataArr.count);
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

- (IBAction)clickPicBtn:(id)sender {
 
    if (_hasImage) {
        _hasImage = false;
        //有图片
        MyPicVC *mypicVC = [[MyPicVC alloc] init];
        mypicVC.RZ_imageArr = self.ImageArr;
        [self.navigationController pushViewController:mypicVC animated:YES];
    }
    else{
        MyPicVC *mypicVC = [[MyPicVC alloc] init];
        [self.navigationController pushViewController:mypicVC animated:YES];
    }
   
    
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

//1.已办理 2.未办理，3.提交上一级 4.无诉求
- (IBAction)clickbutton1:(id)sender {
    //无诉求
    flagChuli = [NSNumber numberWithInt:4];
    _button1.selected = YES;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
}

- (IBAction)clickbutton2:(id)sender {
    //当场办结
    flagChuli = [NSNumber numberWithInt:1];
    _button1.selected = NO;
    _button2.selected = YES;
    _button3.selected = NO;
    _button4.selected = NO;
}


- (IBAction)clickbutton3:(id)sender {
    //正在办理
    flagChuli = [NSNumber numberWithInt:2];
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = YES;
    _button4.selected = NO;
}
//
- (IBAction)clickbutton4:(id)sender {
    // 提交上一级
    flagChuli = [NSNumber numberWithInt:3];
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = YES;
}

@end
