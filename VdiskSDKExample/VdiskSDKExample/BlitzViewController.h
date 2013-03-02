//
//  BlitzViewController.h
//  VdiskSDKExample
//
//  Created by Bruce on 12-11-21.
//
//

#import <UIKit/UIKit.h>
#import <VdiskSDK.h>

@interface BlitzViewController : UIViewController <VdiskRestClientDelegate>

@property (nonatomic, retain) IBOutlet UIButton *blitzButton;

- (IBAction)blitzButtonPressed:(id)sender;

@end
