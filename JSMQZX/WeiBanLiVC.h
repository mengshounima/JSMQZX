//
//  WeiBanLiVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/14.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogCell.h"
#import "GDataXMLNode.h"
@interface WeiBanLiVC : UIViewController
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *_mySearchBar;
}
@property (weak, nonatomic) IBOutlet UITableView *rizhiTableView;
@property (assign,nonatomic) NSInteger flagLogZT;
@end
