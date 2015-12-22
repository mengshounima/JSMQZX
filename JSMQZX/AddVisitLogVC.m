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
    NSString *flagGaiKuang;
    NSString *flagGongXin;
    NSString *flagLeiBie;
    NSString *flagChuli;
    int f1;
    int f2;
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
}
@end

@implementation AddVisitLogVC
-(void)viewWillAppear:(BOOL)animated {
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
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
    _farmerF.text = notific.object;
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
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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
            flagGongXin = [NSString stringWithFormat:@"%@",[commomArr[indexPath.row-1] objectForKey:@"rdwt_id"]];//用于提交接口参数
            _commonF.text = [commomArr[indexPath.row-1] objectForKey:@"rdwt_name"];

        }
           }
    else{
        if (!indexPath.row==0) {
            flagLeiBie = [NSString stringWithFormat:@"%@",[typeArr[indexPath.row-1] objectForKey:@"mqlb_id"]];//用于提交接口参数
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
    // Get the new view controller using [segue destinationViewController].
    FarmersVC *farmers = segue.destinationViewController;
}

//提交日志
- (IBAction)clickSendBtn:(id)sender {
    if (ISNULL(_userLocation)) {
        [MBProgressHUD showError:@"尚未定位成功，请稍等再试"];
        return;
    }
    [MBProgressHUD showMessage:@"提交中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:_dateF.text forKey:@"rz_zfrq"];//日期
    [param setObject:_farmerF.text forKey:@"rz_zfnh"];//农户

    [param setObject:flagGaiKuang forKey:@"rz_mqgk"];//民情概况int1234
    [param setObject:flagLeiBie forKey:@"rz_mqlb"];//类别id
    [param setObject:_needTextView.text forKey:@"rz_msxq"];//需求，文本
    [param setObject:flagChuli forKey:@"rz_ztxx"];//状态信息（处理结果）
    [param setObject:@"2" forKey:@"rz_xxlb"];//日志信息类别 1为固定走访的，2为非固定走访的
    [param setObject:flagGongXin forKey:@"rz_sfgx"];//共性问题类别id
    [param setObject:@"20151201" forKey:@"rz_zjblsj"];//日志最终办理结果的时间
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.longitude] forKey:@"placeLongitude"];//经纬度
    [param setObject:[NSNumber numberWithDouble:_userLocation.location.coordinate.latitude] forKey:@"placeLatitude"];
    [[HttpClient httpClient] requestWithPath:@"/CreateMQLogRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSDictionary *resultDic = (NSArray *)[jsonData objectFromJSONData];
        MyLog(@"%@",resultDic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    

    
}
- (IBAction)clickPicBtn:(id)sender {
    UIActionSheet * sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册", nil];
    }
    [sheet showInView:self.view];

}
#pragma mark - 实现ActionSheet delegate事件
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
                return;// 取消
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera; // 相机
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 相册
                break;
            default:
                break;
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 相册
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self; // 设置代理
    imagePicker.allowsEditing = YES; // 允许编辑
    imagePicker.sourceType = sourceType; // 设置图片源
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
}

#pragma mark - 实现ImagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_picBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_picBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        //_hasImage = true;
        _myImage = image;
    }];
}

- (IBAction)clickbtn1:(id)sender {
    flagGaiKuang = @"1";
    _btn1.selected = YES;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = NO;
}

- (IBAction)clickbtn3:(id)sender {
    flagGaiKuang = @"3";
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = YES;
    _btn4.selected = NO;
}

- (IBAction)clickbtn2:(id)sender {
    flagGaiKuang = @"2";
    _btn1.selected = NO;
    _btn2.selected = YES;
    _btn3.selected = NO;
    _btn4.selected = NO;

}

- (IBAction)clickbtn4:(id)sender {
    flagGaiKuang = @"4";
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = YES;
}
- (IBAction)clickbutton1:(id)sender {
    flagChuli = @"1";
    _button1.selected = YES;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
}

- (IBAction)clickbutton2:(id)sender {
    flagChuli = @"2";
    _button1.selected = NO;
    _button2.selected = YES;
    _button3.selected = NO;
    _button4.selected = NO;
}
- (IBAction)clickbutton4:(id)sender {
    flagChuli = @"4";
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = YES;
}

- (IBAction)clickbutton3:(id)sender {
    flagChuli = @"3";
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = YES;
    _button4.selected = NO;
}
@end
