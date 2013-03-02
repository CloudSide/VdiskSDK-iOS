//
//  RestoreViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestoreViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *filePathTextField;
@property (nonatomic, strong) IBOutlet UITextField *versionTextField;
@property (nonatomic, strong) IBOutlet UIButton *restoreButton;

@end
