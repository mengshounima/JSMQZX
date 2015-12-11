//
//  AddVisitLogVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/8.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "AddVisitLogVC.h"

@interface AddVisitLogVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSDate *_date;
    UIDatePicker *datePicker;
    UITableView *_CommonTable;
    UITableView *_TypeTable;
    NSArray *commomArr;
    NSArray *typeArr;
    JKAlertDialog *alert;
    UIImage *_myImage;
}
@end

@implementation AddVisitLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFarmerFinished:) name:@"selectOneFarmer" object:nil];
    [self initView];
}
-(void)initData{
    commomArr = @[@"不是共性问题",@"水治理环境,推动“五水共治”",@"违章建筑拆除",@"道路沿线环境整治",@"新农村建设"];
    typeArr = @[@"未选择",@"医疗卫生",@"文化教育",@"征地拆迁",@"创业帮扶",@"投诉举报",@"意见建议",@"民生琐事",@"其他"];
}
-(void)selectFarmerFinished:(NSNotification *)notific{
    _farmerF.text = notific.object;
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
    
    _CommonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 230) style:UITableViewStylePlain];
    _CommonTable.delegate = self;
    _CommonTable.dataSource = self;
    
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    

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
        return 5;
    }
    else{
        return 9;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _CommonTable) {
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CommomCell"];
        static NSString *CellIdentifier = @"addCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = commomArr[indexPath.row];
        return cell;

    }
    else{
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
        static NSString *CellIdentifier = @"typeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = typeArr[indexPath.row];
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [alert dismiss];
    if (tableView == _CommonTable) {
        _commonF.text = commomArr[indexPath.row];
    }
    else{
        _typeF.text = typeArr[indexPath.row];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectOneFarmer" object:nil];
}
//提交日志
- (IBAction)clickSendBtn:(id)sender {
    /*[MBProgressHUD showMessage:@"提交中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    UserInfo *user = [[UserInfo shareUserInfo] ReadData];
    NSString *idStr = [NSString stringWithFormat:@"%@",user.useID];
    [param setObject:idStr forKey:@"userId"];
    [param setObject:_dateF.text forKey:@"rz_zfrq"];
    [param setObject:_farmerF.text forKey:@"rz_zfnh"];
    [param setObject:idStr forKey:@"rz_mqgk"];
    [param setObject:idStr forKey:@"rz_mqlb"];
    [param setObject:idStr forKey:@"rz_msxq"];
    [param setObject:idStr forKey:@"rz_ztxx"];
    [param setObject:idStr forKey:@"rz_xxlb"];
    [param setObject:idStr forKey:@"rz_sfgx"];
    [param setObject:idStr forKey:@"rz_zjblsj"];
    [param setObject:@"30" forKey:@"placeLongitude"];
    [param setObject:@"120" forKey:@"placeLatitude"];
    [[HttpClient httpClient] requestWithPath:@"/CreateMQLogRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *arr = (NSArray *)[jsonData objectFromJSONData];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];
    */

    
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
    //[self presentViewController:imagePicker animated:YES completion:nil];
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
}

- (IBAction)clickbtn3:(id)sender {
}

- (IBAction)clickbtn2:(id)sender {
}

- (IBAction)clickbtn4:(id)sender {
}
@end
