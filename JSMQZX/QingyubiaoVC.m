//
//  QingyubiaoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "QingyubiaoVC.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
@interface QingyubiaoVC ()<UITableViewDataSource,UITableViewDelegate,EColumnChartDelegate, EColumnChartDataSource>
{
   JKAlertDialog *alert;
    NSString *flagZJD;
     UITableView *_TypeTable;
    CGRect chatRect;
    
}
@property (nonatomic,weak) NSArray *typeArr;
@property (nonatomic,weak) NSArray *dicArr;
@property (nonatomic, weak) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
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
       _typeArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
    flagZJD = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
    chatRect = _eColumnChart.frame;
}
-(void)initView{
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    
    
    UIButton *FieldBtn = [[UIButton alloc] initWithFrame:_searchField.frame];
    [FieldBtn addTarget:self action:@selector(clickField:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FieldBtn];

    _SearchBtn.layer.cornerRadius = 4;
    
    //表格标题
    NSDate *currentdate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-mm-dd";
    NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
    NSString *yearStr = [nowDateStr substringToIndex:4];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@年度民情统计",yearStr];
    
    
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
#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
    MyLog(@"*************%lu",(unsigned long)[_data count]);
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %ld  Value: %f", (long)eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    //_valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
}
- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
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
- (IBAction)clickSearchBtn:(id)sender {
    [self getUserDataByZJD];

}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"1" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [paramTongji setObject:flagZJD forKey:@"ssz_id"];//统计表类型
    [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisRecord" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // MyLog(@"---**--%@",responseObject);
        
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        _dicArr = [jsonData objectFromJSONData];
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < _dicArr.count; i++)
        {
            NSNumber *value = [_dicArr[i] objectForKey:@"Value"];
            EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value.floatValue index:i unit:@"kws"];
            [temp addObject:eColumnDataModel];
        }
        _data = [NSArray arrayWithArray:temp];
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
        
        _eColumnChart = [[EColumnChart alloc] initWithFrame:chatRect];
        [self.view addSubview:_eColumnChart];
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        //表格标题
        NSDate *currentdate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyy-mm-dd";
        NSString *nowDateStr = [dateformatter stringFromDate:currentdate];
        NSString *yearStr = [nowDateStr substringToIndex:4];
        if (flagZJD == [[DataCenter sharedInstance] ReadData].UserInfo.useType) {
            //此刻未选择
             _titleLabel.text = [NSString stringWithFormat:@"%@年度民情统计",yearStr];
        }
        else
        {
             _titleLabel.text = [NSString stringWithFormat:@"%@年度%@民情统计",yearStr,_searchField.text];
        }
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    
}

@end
