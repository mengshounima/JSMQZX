//
//  NonghuZoufangVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/21.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "NonghuZoufangVC.h"

@interface NonghuZoufangVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TypeTable;
    NSString *flagZJD;
    JKAlertDialog *alert;
}

@property (nonatomic,weak) NSArray *typeArr;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@end

@implementation NonghuZoufangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserData];
}
-(void)initData{
    _typeArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
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
/*
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    
    
}*/
-(void)getUserData{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [alert dismiss];
    if (indexPath.row == 0) {
        flagZJD = @"0";//用于提交接口参数
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

- (IBAction)clickSearchBtn:(id)sender {
    //[self getUserDataByZJD];
    
}
@end
