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
    UITableView *_TypeTable;
    NSString *flagZJD;
    JKAlertDialog *alert;
}
@property (strong, nonatomic) IBOutlet PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic,weak) NSArray *typeArr;

@property (nonatomic,strong) NSArray *resultLabelArr;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) UILabel *selLabel;

@end

@implementation MinshengXvqiuVC

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
    [FieldBtn addTarget:self action:@selector(clickField:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FieldBtn];
    
}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"3" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [paramTongji setObject:flagZJD forKey:@"ssz_id"];//统计表类型
    [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
    [paramTongji setObject:@"20" forKey:@"rowscount"];//统计表类型
    [paramTongji setObject:@"1" forKey:@"page"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisInfo" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
         MyLog(@"---**--%@",jsonData);
        NSArray *resultArr = [jsonData objectFromJSONData];
        NSMutableArray *labelMutArr = [[NSMutableArray alloc] init];
        self.valueArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic  in resultArr) {
            NSNumber *value = [dic objectForKey:@"Value"];
            NSString *labelstr = [dic objectForKey:@"Label"];
            [self.valueArray addObject:value];//数据
            [labelMutArr addObject:labelstr];//文本
        }
        _resultLabelArr = [labelMutArr copy];
        /* NSNumber *beiZoufangI = [resultArr[0] objectForKey:@"Value"];//数量
         NSNumber *weiZoufangI = [resultArr[1] objectForKey:@"Value"];//*/
        
        /*NSNumber *beiZoufangI = [NSNumber numberWithInt:60];//数量
        NSNumber *weiZoufangI = [NSNumber numberWithInt:40];//*/
        
        
        self.colorArray = [NSMutableArray arrayWithObjects:
                           [UIColor colorWithHue:((0/8)%20)/20.0+0.02 saturation:(0%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(1%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(2%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(3%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(4%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(5%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(6%8+3)/10.0 brightness:91/100.0 alpha:1],
                           [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(7%8+3)/10.0 brightness:91/100.0 alpha:1],
                           
                           nil];
        
        [self.pieContainer removeFromSuperview];
        //add shadow img
        CGRect pieFrame = CGRectMake((SCREEN_WIDTH - PIE_HEIGHT) / 2, 120, PIE_HEIGHT, PIE_HEIGHT);
        
        UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
        UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
        shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT*0.92, shadowImg.size.width/2, shadowImg.size.height/2);
        [self.view addSubview:shadowImgView];
        
        self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
        self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
        self.pieChartView.delegate = self;
        [self.pieContainer addSubview:self.pieChartView];
        //[self.pieChartView setAmountText:@"内部"];
        [self.view addSubview:self.pieContainer];
        
        [self.selLabel removeFromSuperview];
        self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pieContainer.frame)+30, SCREEN_WIDTH-20, 21)];
        self.selLabel.backgroundColor = [UIColor clearColor];
        self.selLabel.textAlignment = NSTextAlignmentCenter;
        self.selLabel.font = [UIFont systemFontOfSize:17];
        self.selLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.selLabel];
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        [self.pieChartView reloadChart];
        
        
        
        //表格标题
        NSDate *currentdate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyy-mm-dd";
        NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
        NSString *yearStr = [nowDateStr substringToIndex:4];
        /*if (flagZJD == [[DataCenter sharedInstance] ReadData].UserInfo.useType) {
         //此刻未选择
         [self.pieChartView setTitleText:[NSString stringWithFormat:@"%@年度民情统计",yearStr]];
         }
         else
         {
         [self.pieChartView setTitleText:[NSString stringWithFormat:@"%@年度%@民情统计",yearStr,_searchField.text]];
         ;
         }*/
        
        
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

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    //if (index ==0) {
        self.selLabel.text = [NSString stringWithFormat:@"%@ %2.2f%@",_resultLabelArr[index] ,per*100,@"%"];
  /*  }
    else
    {
        self.selLabel.text = [NSString stringWithFormat:@"%@  %2.2f%@",_resultLabelArr[index],per*100,@"%"];
    }*/
    
    // self.selLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    /* self.inOut = !self.inOut;
     self.pieChartView.delegate = nil;
     [self.pieChartView removeFromSuperview];
     self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
     self.pieChartView.delegate = self;
     [self.pieContainer addSubview:self.pieChartView];
     [self.pieChartView reloadChart];
     
     if (self.inOut) {
     [self.pieChartView setTitleText:@"支出总计"];
     [self.pieChartView setAmountText:@"-2456.0"];
     
     }else{
     [self.pieChartView setTitleText:@"收入总计"];
     [self.pieChartView setAmountText:@"+567.23"];
     }*/
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
