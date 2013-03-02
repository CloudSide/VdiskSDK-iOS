//
//  CreateFolderViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateFolderViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *folderNameTextField;
@property (nonatomic, strong) IBOutlet UIButton *createFolderButton;
@property (nonatomic, strong) NSString *parentPath;

@end
