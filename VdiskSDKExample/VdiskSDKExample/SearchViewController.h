//
//  SearchViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSString *path;

@end
