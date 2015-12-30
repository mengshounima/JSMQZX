//
//  UserInfoTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "UserInfoTableVC.h"

@interface UserInfoTableVC ()

@end

@implementation UserInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"UaerInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row ==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"登录编号:%@",[[DataCenter sharedInstance] ReadData].UserInfo.loginName];
    }
    else if (indexPath.row ==1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"真实姓名:%@",[[DataCenter sharedInstance] ReadData].UserInfo.name];
        
        
    }
    else if (indexPath.row ==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"镇、社区:%@",[[DataCenter sharedInstance] ReadData].UserInfo.departmentName];
        ;
        
    }
    else if (indexPath.row ==3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"职务:%@",[[DataCenter sharedInstance] ReadData].UserInfo.administerName];
        ;
        
    }
    else if (indexPath.row ==4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"是否党员:%@",[[DataCenter sharedInstance] ReadData].UserInfo.ismember];
        
    }
    else if (indexPath.row ==5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系方式:%@",[[DataCenter sharedInstance] ReadData].UserInfo.phone];
        
    }

    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"登录时间:%@",[[DataCenter sharedInstance] ReadData].UserInfo.lastLoginTime];
        
    }
    
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
