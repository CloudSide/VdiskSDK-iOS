//
//  VdiskSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Bruce Chen (weibo: @一个开发者) on 12-6-15.
//
//  Copyright (c) 2012 Sina Vdisk. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize switcher = _switcher;

- (void)onSwitcherChanged {

    if (_switcher.isOn) {
        
        
        /*
        NSString *weiboAccessToken = [(AppDelegate *)[[UIApplication sharedApplication] delegate] weiboAccessToken];
        
        if (weiboAccessToken != nil && [weiboAccessToken length] > 0) {
            
            [[VdiskSession sharedSession] enabledAndSetExternalWeiboAccessToken:weiboAccessToken];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Weibo Access Token Empty!" message:@"Please assignment: \n- [AppDelegate setWeiboAccessToken:]" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [alertView show];
            [alertView release];
            
            [_switcher setOn:NO animated:YES];
        }
         */
        
    } else {
        
        /*
        [[VdiskSession sharedSession] disabledExternalWeiboAccessToken];
         */
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [_switcher addTarget:self action:@selector(onSwitcherChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    
    [_switcher release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onLinkButtionPressed {

    [[VdiskSession sharedSession] setRootViewController:self];
    
    if (_switcher.isOn) {
    
        [[VdiskSession sharedSession] linkWithSessionType:kVdiskSessionTypeWeiboAccessToken];
        
    } else {
    
        [[VdiskSession sharedSession] linkWithSessionType:kVdiskSessionTypeDefault];
    }
}


#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    
    NSLog(@"sinaweiboDidLogOut");

}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error {
    
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error {
    
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);

}

@end
