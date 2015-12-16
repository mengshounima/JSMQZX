//
//  ModifyLogVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ModifyLogVC.h"

@interface ModifyLogVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate>
{
   NSDictionary  *LogDic;
    NSInteger f1;//共性
    NSInteger f2;//类别
    NSInteger f3;//日志详情
    NSInteger f4;//照片列表
    NSArray *imageArr;
    NSArray *commomArr;
    NSArray *typeArr;
    NSString *flagGaiKuang;
    NSString *flagGongXin;
    NSString *flagLeiBie;
    NSString *flagChuli;
    UIDatePicker *datePicker;
    UITableView *_CommonTable;
    UITableView *_TypeTable;
    JKAlertDialog *alert;
}
@end

@implementation ModifyLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self getViewNetData];//构建页面
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initData{
    flagGaiKuang = 0;
    flagLeiBie = 0;
    flagGongXin = 0;
    flagChuli = 0;
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
    
    
    _CommonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 230) style:UITableViewStylePlain];
    _CommonTable.delegate = self;
    _CommonTable.dataSource = self;
    
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
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
}
//点击图片按钮
- (IBAction)clickPicBtn:(id)sender{
    [self performSegueWithIdentifier:@"ModiFyLogToPicVC" sender:imageArr];
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

-(void)getViewNetData{
    //获取共性问题list
    [MBProgressHUD showMessage:@"构建页面"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[UserInfo sharedInstance] ReadData].useID;
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
        if (f1==1&&f2==1&&f3==1&f4==1) {
            [MBProgressHUD hideHUD];
        }
        NSData* jsonData = [self XMLString:responseObject];
        imageArr = (NSArray *)[jsonData objectFromJSONData];
        MyLog(@"%@",imageArr);//图片集合
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ModiFyLogToPicVC"]) {
        //照片浏览
        PicViewController *picVC = segue.destinationViewController;
        picVC.RZ_imageArr = sender;
    }
}


@end
