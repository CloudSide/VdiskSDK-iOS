//
//  MoveViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *sourcePathTextField;
@property (nonatomic, strong) IBOutlet UITextField *destinationPathTextField;
@property (nonatomic, strong) IBOutlet UIButton *moveButton;

@end
