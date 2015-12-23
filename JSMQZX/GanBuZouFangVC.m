//
//  GanBuZouFangVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/24.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "GanBuZouFangVC.h"

@interface GanBuZouFangVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TypeTable;
    NSString *flagZJD;
    JKAlertDialog *alert;
}
@property (nonatomic,weak) NSArray *typeArr;

@end

@implementation GanBuZouFangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserDataByZJD];
   
}
-(void)initData{
    _typeArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
    flagZJD = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
}
-(void)initView{
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    
    _searchBtn.layer.cornerRadius = 4;
    UIButton *FieldBtn = [[UIButton alloc] initWithFrame:_searchField.frame];
    //[FieldBtn setBackgroundColor:[UIColor greenColor]];
    [FieldBtn addTarget:self action:@selector(clickField:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FieldBtn];
    
}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"2" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [paramTongji setObject:flagZJD forKey:@"ssz_id"];//统计表类型
    [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
    [paramTongji setObject:@"20" forKey:@"rowscount"];//统计表类型
    [paramTongji setObject:@"1" forKey:@"page"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisInfo" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"---**--%@",responseObject);
        
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *resultArr = [jsonData objectFromJSONData];
        NSNumber *ZGBValue = [resultArr[0] objectForKey:@"zjd_zgb_zfrzs"];//走访数
        NSNumber *ZGBBig = [resultArr[1] objectForKey:@"zjd_zgb_zfnhs"];//走访数大数
        
        NSNumber *CGBValue = [resultArr[0] objectForKey:@"zjd_cgb_zfrzs"];//走访数
        NSNumber *CGBBig = [resultArr[1] objectForKey:@"zjd_cgb_zfnhs"];//走访数大数

        
        
        
        NSMutableArray *textIndicators = [[NSMutableArray alloc] initWithObjects:@"镇干部", @"村干部", nil];
        NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:ZGBValue, CGBValue, nil];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        JXBarChartView *barChartView = [[JXBarChartView alloc] initWithFrame:frame startPoint:CGPointMake(20, 20) values:values maxValue:12736 textIndicators:textIndicators textColor:[UIColor blackColor] barHeight:30 barMaxWidth:200 gradient:nil];
        [self.view addSubview:barChartView];

        
        NSNumber *beiZoufangI = [NSNumber numberWithInt:60];//数量
        NSNumber *weiZoufangI = [NSNumber numberWithInt:40];//
        
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
    [alert dismiss];
    if (indexPath.row == 0) {
        //传管理员自己的ssz
        flagZJD = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
        _searchField.text = @"选择镇(街道)/村(社区)";
    }
    else{
        flagZJD = [NSString stringWithFormat:@"%@",[_typeArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
        _searchField.text = [_typeArr[indexPath.row-1] objectForKey:@"zjd_name"];
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZJDCellQY";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"选择镇(街道)/村(社区)";
    }
    else{
        cell.textLabel.text = [_typeArr[indexPath.row-1] objectForKey:@"zjd_name"];
    }
    return  cell;
    
}
-(void)clickField:(UIButton *)button{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/社区" message:@""];
    alert.contentView =  _TypeTable;
    
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

@end
