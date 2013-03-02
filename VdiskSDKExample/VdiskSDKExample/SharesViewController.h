//
//  SharesViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharesViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *filePathTextField;
@property (nonatomic, strong) IBOutlet UIButton *createLinkButton;

- (IBAction)onCreateLinkButtonPressed:(id)sender;

@end
