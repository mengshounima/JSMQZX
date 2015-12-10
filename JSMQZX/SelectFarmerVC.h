//
//  SelectFarmerVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/10.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "SelectFarmerCell.h"
#import "FarmerInfoTableVC.h"
@interface SelectFarmerVC : UIViewController
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,weak) NSDictionary *gridInfo;
@property (weak, nonatomic) IBOutlet UITableView *FarmerTable;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@end
