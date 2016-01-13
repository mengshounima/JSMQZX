//
//  MinshengXvqiuVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/23.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "MinshengXvqiuVC.h"

@interface MinshengXvqiuVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_ZJDTable;
    UITableView *_CUNTable;
    JKAlertDialog *alert;
}

@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) UILabel *selLabel;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *titleArr;
@end

@implementation MinshengXvqiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserDataByZJD];
}
-(void)initData{
    NSString *powerStr = [NSString stringWithFormat:@"%@",[[DataCenter sharedInstance] ReadData].UserInfo.power];
    
    if([powerStr isEqualToString:@"3"]){
        MyLog(@"镇干部");
        _ZJDBtn.enabled = NO;
        [_ZJDBtn setTitle:[[DataCenter sharedInstance] ReadData].UserInfo.administerName forState:UIControlStateNormal];
        _ZJDFlag = [NSString stringWithFormat:@"%@",[[DataCenter sharedInstance] ReadData].UserInfo.useType];
        [self getCunData:_ZJDFlag];
    }
    else
    {
        _CUNBtn.enabled = NO;
        _ZJDArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
        
    }

}
-(void)initView{
    _ZJDBtn.layer.cornerRadius = 4;
    _CUNBtn.layer.cornerRadius = 4;
    _ZJDTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _ZJDTable.delegate = self;
    _ZJDTable.dataSource = self;
    
    _CUNTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _CUNTable.delegate = self;
    _CUNTable.dataSource = self;
    
    
    _SearchBtn.layer.cornerRadius = 4;
    //表格标题
    NSDate *currentdate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-mm-dd";
    NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
    NSString *yearStr = [nowDateStr substringToIndex:4];

     _titleLabel.text = [NSString stringWithFormat:@"%@年度民情统计",yearStr];
}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"3" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    if (ISNULLSTR(_ZJDFlag)) {
        [paramTongji setObject:@"" forKey:@"ssz_id"];//统计表类型
    }
    else{
        [paramTongji setObject:_ZJDFlag forKey:@"ssz_id"];//统计表类型
    }
    if (ISNULLSTR(_CUNFlag)) {
        [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
        
    }
    else{
        [paramTongji setObject:_CUNFlag forKey:@"cun_id"];//统计表类型
        
    }
    
    [paramTongji setObject:@"20" forKey:@"rowscount"];//统计表类型
    [paramTongji setObject:@"1" forKey:@"page"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisInfo" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"---**--%@",responseObject);
        
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *resultArr = [jsonData objectFromJSONData];
        NSMutableArray *coms = [[NSMutableArray alloc] init];

        for (int i=0;i<resultArr.count;i++) {
            NSNumber *value = [resultArr[i] objectForKey:@"Value"];
            NSString *label = [resultArr[i] objectForKey:@"Label"];
            //NSNumber *Ratio = [resultArr[i] objectForKey:@"Ratio"];
            NSDictionary *dic = @{@"title":[NSString stringWithFormat:@"%@%@",label,value],@"value":value};
            [coms addObject:dic];
        }
        if (_pieChart) {
            [_pieChart removeFromSuperview];
        }
        int height = _ChatContianerV.size.height*0.7;
        int width = _ChatContianerV.size.width;
        _pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0,0,width,height)];
        [_pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_ChatContianerV addSubview:_pieChart];
        [_pieChart setDiameter:width/2];
        
        [_pieChart setSameColorLabel:YES];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            _pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
            _pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        }
        
        NSMutableArray *components = [NSMutableArray array];
        MyLog(@"---**--%@",coms);
        for (int i=0; i<resultArr.count; i++)
        {
            NSDictionary *item = coms[i];
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];//传入number
            [components addObject:component];
            
            if (i==0)
            {
                [component setColour:PCColorYellow];
            }
            else if (i==1)
            {
                [component setColour:PCColorGreen];
            }
            else if (i==2)
            {
                [component setColour:PCColorOrange];
            }
            else if (i==3)
            {
                [component setColour:PCColorRed];
            }
            else if (i==4)
            {
                [component setColour:PCColorBlue];
            }
            else if (i==5)
            {
                [component setColour:[UIColor purpleColor]];
            }
            else if (i==6)
            {
                [component setColour:[UIColor darkGrayColor]];
            }

            else if (i==7)
            {
                [component setColour:[UIColor cyanColor]];
            }

            else if (i==8)
            {
                [component setColour:[UIColor brownColor]];
            }


        }
        [_pieChart setComponents:components];
        //表格标题
        NSDate *currentdate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyy-mm-dd";
        NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
        NSString *yearStr = [nowDateStr substringToIndex:4];
        if (ISNULLSTR(_ZJDFlag)&&ISNULLSTR(_CUNFlag)) {
            //此刻未选择
            _titleLabel.text = [NSString stringWithFormat:@"%@年度民生需求统计",yearStr];
        }
        else if (!ISNULLSTR(_ZJDFlag)&&ISNULLSTR(_CUNFlag))
        {
            _titleLabel.text = [NSString stringWithFormat:@"%@年度%@民生需求统计",yearStr,_ZJDBtn.titleLabel.text];
        }
        else if (ISNULLSTR(_ZJDFlag)&&!ISNULLSTR(_CUNFlag))
        {
            _titleLabel.text = [NSString stringWithFormat:@"%@年度%@民生需求统计",yearStr,_CUNBtn.titleLabel.text];
        }
        else{
            _titleLabel.text = [NSString stringWithFormat:@"%@年度%@%@民生需求统计",yearStr,_ZJDBtn.titleLabel.text,_CUNBtn.titleLabel.text];
        }
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        [alert dismiss];
        [_CUNBtn setTitle:@"选择村(社区)" forState: UIControlStateNormal ];
        _CUNFlag = @"";
        if (indexPath.row == 0) {
            _ZJDFlag = @"";
            [_ZJDBtn setTitle:@"选择镇(街道)" forState: UIControlStateNormal ];
            _CUNBtn.enabled = NO;
        }
        else{
            _ZJDFlag = [NSString stringWithFormat:@"%@",[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
            [_ZJDBtn setTitle:[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"] forState: UIControlStateNormal ];
            //作请求，得到该镇内的村
            [self getCunData:_ZJDFlag];
        }
        
    }
    else{
        [alert dismiss];
        if (indexPath.row == 0) {
            _CUNFlag = @"";
            [_CUNBtn setTitle:@"选择村(社区)" forState: UIControlStateNormal ];
        }
        else{
            _CUNFlag = [NSString stringWithFormat:@"%@",[_CUNArr[indexPath.row-1] objectForKey:@"cun_id"]];//用于提交接口参数
            [_CUNBtn setTitle:[_CUNArr[indexPath.row-1] objectForKey:@"cun_name"] forState: UIControlStateNormal ];
        }
        
    }
}

-(void)getCunData:(NSString *)ZJD_ID{
    //[MBProgressHUD showMessage:@"获取该镇的村列表"];
    //获取下属单位
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:ZJD_ID forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = (NSArray *)[jsonData objectFromJSONData];
        
        [_CUNTable reloadData];
        _CUNBtn.enabled = YES;//可选
        MyLog(@"村%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ZJDTable) {
        return _ZJDArr.count+1;
    }
    else {
        return _CUNArr.count +1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        static NSString *ID = @"nhBzjdCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择镇(街道)";
        }
        else{
            cell.textLabel.text = [_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"];
        }
        return  cell;
        
    }
    else
    {
        static NSString *ID = @"nhBcunCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择村(社区)";
        }
        else{
            cell.textLabel.text = [_CUNArr[indexPath.row-1] objectForKey:@"cun_name"];
        }
        return  cell;
        
    }
    
}
//点击镇街道
- (IBAction)clickZJDBtn:(id)sender{
    //弹框
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/街道" message:@""];
    alert.contentView =  _ZJDTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
    
}
- (IBAction)clickCUNBtn:(id)sender{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择村/社区" message:@""];
    alert.contentView =  _CUNTable;
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
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

- (IBAction)clickSearchBtn:(id)sender {
    [self getUserDataByZJD];
    
}


@end
