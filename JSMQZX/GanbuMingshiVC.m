//
//  GanbuMingshiVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/29.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "GanbuMingshiVC.h"

@interface GanbuMingshiVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_ZJDTable;
    UITableView *_CUNTable;
    JKAlertDialog *alert;
    NSInteger cellRowcount;
}
@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;

@property (nonatomic,strong) NSArray *zgbDataArr;
@property (nonatomic,strong) NSArray *zgbZSArr;

@property (nonatomic,strong) NSArray *cgbZSArr;
@property (nonatomic,strong) NSArray *cgbDataArr;
@property (nonatomic,strong) NSArray *titleArr;


@property (nonatomic,strong) NSArray *gl_bjlArr;
@property (nonatomic,strong) NSArray *gl_zsxmArr;
@property (nonatomic,strong) NSArray *gl_msbljfArr;
@property (nonatomic,strong) NSArray *gl_mssjfArr;
@property (nonatomic,strong) NSArray *gl_mssjblhjArr;

@end

@implementation GanbuMingshiVC
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
}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"5" forKey:@"AnalysisType"];//统计表类型
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
        cellRowcount = resultArr.count;
        if (ISNULLSTR(_ZJDFlag)) {
            NSMutableArray *zgbMut = [[NSMutableArray alloc] init];
            NSMutableArray *zgbZSMut = [[NSMutableArray alloc] init];
            NSMutableArray *cgbMut = [[NSMutableArray alloc] init];
            NSMutableArray *cgbZSMut = [[NSMutableArray alloc] init];
            NSMutableArray *titleMut = [[NSMutableArray alloc] init];
            for (int i=0;i<resultArr.count;i++) {
                NSNumber *value1 = [resultArr[i] objectForKey:@"zjd_zgb_zfnhs"];
                [zgbMut addObject:value1];
                NSNumber *value2 = [resultArr[i] objectForKey:@"zjd_zgb_zfrzs"];//总数，显示
                [zgbZSMut addObject:value2];
                NSNumber *value3 = [resultArr[i] objectForKey:@"zjd_cgb_zfnhs"];
                [cgbMut addObject:value3];
                NSNumber *value4 = [resultArr[i] objectForKey:@"zjd_cgb_zfrzs"];
                [cgbZSMut addObject:value4];
                
                
                NSString *label = [resultArr[i] objectForKey:@"zjd_name"];
                [titleMut addObject:label];
            }
            
            _zgbDataArr = [zgbMut mutableCopy];
            _zgbZSArr= [zgbZSMut mutableCopy];
            _cgbDataArr = [cgbMut mutableCopy];
            _cgbZSArr = [cgbZSMut mutableCopy];
            
            _titleArr = [titleMut mutableCopy];
            [_myTableView reloadData];
            _myTableView.hidden = NO;
            _InfoTableView.hidden =YES;

        }
        else{
            /*NSMutableArray *zgbMut = [[NSMutableArray alloc] init];
             NSMutableArray *zgbZSMut = [[NSMutableArray alloc] init];
             NSMutableArray *cgbMut = [[NSMutableArray alloc] init];
             NSMutableArray *cgbZSMut = [[NSMutableArray alloc] init];*/
            NSMutableArray *gl_bjlMut = [[NSMutableArray alloc] init];
            NSMutableArray *nameMut = [[NSMutableArray alloc] init];//姓名
            NSMutableArray *gl_msbljfMut = [[NSMutableArray alloc] init];
            NSMutableArray *gl_mssjfMut = [[NSMutableArray alloc] init];         NSMutableArray *gl_mssjblhjMut = [[NSMutableArray alloc] init];            for (int i=0;i<resultArr.count;i++) {
                /*NSNumber *value1 = [resultArr[i] objectForKey:@"zjd_zgb_zfnhs"];
                 [zgbMut addObject:value1];
                 NSNumber *value2 = [resultArr[i] objectForKey:@"zjd_zgb_zfrzs"];//总数，显示
                 [zgbZSMut addObject:value2];
                 NSNumber *value3 = [resultArr[i] objectForKey:@"zjd_cgb_zfnhs"];
                 [cgbMut addObject:value3];
                 NSNumber *value4 = [resultArr[i] objectForKey:@"zjd_cgb_zfrzs"];
                 [cgbZSMut addObject:value4];*/
                
                
                NSNumber *gl_bjl = [resultArr[i] objectForKey:@"gl_bjl"];
                [gl_bjlMut addObject:gl_bjl];//办结率
                
                NSString *nameStr = [resultArr[i] objectForKey:@"gl_zsxm"];
                [nameMut addObject:nameStr];//姓名
                
                NSNumber *gl_msbljf = [resultArr[i] objectForKey:@"gl_msbljf"];
                [gl_msbljfMut addObject:gl_msbljf];//gl_msbljf办理积分
                
                NSNumber *gl_mssjf = [resultArr[i] objectForKey:@"gl_mssjf"];
                [gl_mssjfMut addObject:gl_mssjf];//gl_mssjf收集积分
                
                NSNumber *gl_mssjblhj = [resultArr[i] objectForKey:@"gl_mssjblhj"];
                [gl_mssjblhjMut addObject:gl_mssjblhj];//gl_mssjblhj办理积分合计
                
                
                
            }
            _gl_bjlArr = [gl_bjlMut mutableCopy];
            _gl_zsxmArr = [nameMut mutableCopy];
            _gl_msbljfArr = [gl_msbljfMut mutableCopy];
            _gl_mssjfArr = [gl_mssjfMut mutableCopy];
            _gl_mssjblhjArr = [gl_mssjblhjMut mutableCopy];
            /*_zgbDataArr = [zgbMut mutableCopy];
             _zgbZSArr= [zgbZSMut mutableCopy];
             _cgbDataArr = [cgbMut mutableCopy];
             _cgbZSArr = [cgbZSMut mutableCopy];
             
             _titleArr = [titleMut mutableCopy];*/
            
            [_InfoTableView reloadData];
            _InfoTableView.hidden =NO;
            _myTableView.hidden = YES;
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
    else if (tableView == _CUNTable) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ZJDTable) {
        return _ZJDArr.count+1;
    }
    else if (tableView == _CUNTable){
        return _CUNArr.count +1;
    }
    else{
        return cellRowcount;
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
    else if (tableView == _CUNTable)
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
    else if(tableView == _myTableView){
        static NSString *ID = @"GanbuzoufCell";
        GanbuMingshiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GanbuZoufangCell" owner:nil options:nil] lastObject];
        }
        NSNumber *zgbData= _zgbDataArr[indexPath.row];
        NSNumber *zgbZS=_zgbZSArr[indexPath.row];
        NSNumber *cgbData= _cgbDataArr[indexPath.row];
        NSNumber *cgbZS=_cgbZSArr[indexPath.row];
        float ZJDpercent;
        float CJDpercent ;
        if (zgbData.floatValue==0) {
            ZJDpercent = 0;
        }
        else{
            ZJDpercent  = zgbZS.floatValue/zgbData.floatValue;
        }
        
        
        if (cgbData.floatValue==0) {
            CJDpercent = 0;
        }
        else{
            CJDpercent  = cgbZS.floatValue/cgbData.floatValue;
        }

        NSDictionary *paramDic =  @{@"title":_titleArr[indexPath.row],@"ZJDpercent":[NSNumber numberWithFloat:ZJDpercent],@"CJDpercent":[NSNumber numberWithFloat:CJDpercent],@"ZJDZS":zgbZS,@"CJDZS":cgbZS};
        [cell UpdateWithInfoDic:paramDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    //办理详情
    else{
        static NSString *ID = @"MingshiBanliInfo";
        MingshiBanliInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MingshiBanliInfoCell" owner:nil options:nil] lastObject];
        }
        /*    _gl_bjlArr = [gl_bjlMut mutableCopy];
         _gl_zsxmArr = [nameMut mutableCopy];
         _gl_msbljfArr = [gl_msbljfMut mutableCopy];
         _gl_mssjfArr = [gl_mssjfMut mutableCopy];
         _gl_mssjblhjArr = [gl_mssjblhjMut mutableCopy];*/
        
        NSDictionary *paramDic =  @{@"name":_gl_zsxmArr[indexPath.row],@"gl_zfl":_gl_bjlArr[indexPath.row],@"gl_zfjcf":_gl_msbljfArr[indexPath.row],@"gl_zffjf":_gl_mssjfArr[indexPath.row],@"gl_zfhj":_gl_mssjblhjArr[indexPath.row]};
        [cell updateCellWithInfoDic:paramDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }

    
}
- (IBAction)clickSearchBtn:(id)sender{
    [self getUserDataByZJD];
    
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


@end
