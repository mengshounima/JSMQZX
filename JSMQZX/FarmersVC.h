//
//  FarmersVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/9.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "SelectFarmerVC.h"
@interface FarmersVC : UIViewController
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *_mySearchBar;
}
@property (weak, nonatomic) IBOutlet UITableView *GridTable;
@property (weak, nonatomic) NSNumber *FlagSuiji ;

@end
