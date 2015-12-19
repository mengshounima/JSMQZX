//
//  DangyuanBaodaoTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/18.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "DangyuanBaodaoTableVC.h"

@interface DangyuanBaodaoTableVC ()
@property (nonatomic,weak)  NSDictionary *BaodaoInfoDic;
@end

@implementation DangyuanBaodaoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInfoData];
}
//获取党员报到信息
-(void)getInfoData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *paramList = [[NSMutableDictionary alloc] init];
    [paramList setObject:[_infoDic objectForKey:@"bd_id"] forKey:@"BD_ID"];
    [paramList setObject:[_infoDic objectForKey:@"bdxx_id"] forKey:@"ID"];
    [paramList setObject:[[UserInfo sharedInstance] ReadData].useID forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDYBDInfo" method:TBHttpRequestPost parameters:paramList prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _BaodaoInfoDic = (NSDictionary *)[jsonData objectFromJSONData];
        
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
    MyLog(@"***%@",str);
    return  jsonData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"DangyuanInfoCell";
    //if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        //cell内容
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"党员姓名:%@",[_BaodaoInfoDic objectForKey:@"bd_name"]];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"所属党委:%@",[_BaodaoInfoDic objectForKey:@"dw_name"]];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"工作单位:%@",[_BaodaoInfoDic objectForKey:@"bd_gzdw"]];
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"联系电话:%@",[_BaodaoInfoDic objectForKey:@"bd_lxdh"]];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"职务:%@",[_BaodaoInfoDic objectForKey:@"bd_zw"]];
        }
        //return cell;
   // }
    //else if(indexPath.section == 1){
   
        
  //  }
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
