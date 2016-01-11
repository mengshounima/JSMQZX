//
//  QingyubiaoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "QingyubiaoVC.h"

@interface QingyubiaoVC ()<UITableViewDataSource,UITableViewDelegate>
{
   JKAlertDialog *alert;
    UITableView *_ZJDTable;
    UITableView *_CUNTable;
    CGRect chatRect;
    
}
@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;
@property (nonatomic,weak) NSArray *dicArr;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation QingyubiaoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserDataByZJD];
    
}
-(void)initData{
       _ZJDArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
}
-(void)initView{
    _CUNBtn.enabled = NO;
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
    
    int height = _ChartContainerV.size.height;
    int width = _ChartContainerV.size.width;
    // Chart View
    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _chartView.backgroundColor = [UIColor clearColor];
    
    [_ChartContainerV addSubview:_chartView];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        [_CUNBtn setTitle:@"选择村(社区)" forState: UIControlStateNormal ];
        _CUNFlag = @"";
        [alert dismiss];
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
    [MBProgressHUD showMessage:@"获取该镇的村列表"];
    //获取下属单位
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:ZJD_ID forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = (NSArray *)[jsonData objectFromJSONData];
        
        [_CUNTable reloadData];
        _CUNBtn.enabled = YES;//可选
        MyLog(@"村%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
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
- (IBAction)clickSearchBtn:(id)sender{
    [self getUserDataByZJD];
    
    
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
        static NSString *ID = @"QYBzjdCell";
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
        static NSString *ID = @"QYBcunCell";
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

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"1" forKey:@"AnalysisType"];//统计表类型
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
        
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        _dicArr = [jsonData objectFromJSONData];
           
           NSMutableArray *titleMut = [[NSMutableArray alloc] init];
           NSMutableArray *valueMut = [[NSMutableArray alloc] init];
           NSMutableArray *percentMut = [[NSMutableArray alloc] init];
           for (int i=0;i<_dicArr.count;i++) {
               NSNumber *value = [_dicArr[i] objectForKey:@"Value"];
               [valueMut addObject:value];
               NSString *label = [_dicArr[i] objectForKey:@"Label"];
               [titleMut addObject:label];
               NSNumber *Ratio = [_dicArr[i] objectForKey:@"Ratio"];
               [percentMut addObject:Ratio];
           }
           
          NSArray *values = [valueMut mutableCopy];
            TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:values                                                               fillColor:[[UIColor greenColor] colorWithAlphaComponent:0.5]
                                                             strokeColor:[UIColor greenColor]];
           NSArray *labels =[titleMut mutableCopy];
           
          TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:labels
                                                         dataSets:@[dataSet1]
                                                         animated:YES];
           [_chartView loadBarChart:bar];

        //表格标题
        NSDate *currentdate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyy-mm-dd";
        NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
        NSString *yearStr = [nowDateStr substringToIndex:4];
        if (ISNULLSTR(_ZJDFlag)&&ISNULLSTR(_CUNFlag)) {
            //此刻未选择
             _titleLabel.text = [NSString stringWithFormat:@"%@年度民情统计",yearStr];
        }
        else if (!ISNULLSTR(_ZJDFlag)&&ISNULLSTR(_CUNFlag))
        {
             _titleLabel.text = [NSString stringWithFormat:@"%@年度%@民情统计",yearStr,_ZJDBtn.titleLabel.text];
        }
        else if (ISNULLSTR(_ZJDFlag)&&!ISNULLSTR(_CUNFlag))
        {
            _titleLabel.text = [NSString stringWithFormat:@"%@年度%@民情统计",yearStr,_CUNBtn.titleLabel.text];
        }
        else{
            _titleLabel.text = [NSString stringWithFormat:@"%@年度%@%@民情统计",yearStr,_ZJDBtn.titleLabel.text,_CUNBtn.titleLabel.text];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    
}

@end
