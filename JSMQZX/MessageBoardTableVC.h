//
//  MessageBoardTableVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "mailCell.h"
#import "mailInfoVC.h"
@interface MessageBoardTableVC : UITableViewController
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *_mySearchBar;
}
@end
