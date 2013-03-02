//
//  CopyViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *sourcePathTextField;
@property (nonatomic, strong) IBOutlet UITextField *destinationPathTextField;
@property (nonatomic, strong) IBOutlet UIButton *aCopButton;

@end
