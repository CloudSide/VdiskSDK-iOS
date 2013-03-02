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

#import "AccountInfoViewController.h"
#import "VdiskSDK.h"

@interface AccountInfoViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_restClient;
}

@end

@implementation AccountInfoViewController

@synthesize getAccountInfoButton = _getAccountInfoButton;
@synthesize textView = _textView;

- (void)dealloc {

    [_restClient cancelAllRequests];
    _restClient.delegate = nil;
    [_restClient release];
    
    [_getAccountInfoButton release];
    [_textView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        self.title = @"Account info";
        _restClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        _restClient.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    /*
    [self onGetAccountInfoButtonPressed:nil];
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onGetAccountInfoButtonPressed:(id)sender {

    [_restClient loadAccountInfo];
    
    [_getAccountInfoButton setEnabled:NO];
    [_getAccountInfoButton setTitle:@"Getting..." forState:UIControlStateNormal];
}

#pragma mark - VdiskRestClientDelegate


- (void)restClient:(VdiskRestClient *)client loadAccountInfoFailedWithError:(NSError *)error {

    [_getAccountInfoButton setEnabled:YES];
    [_getAccountInfoButton setTitle:@"Get account info" forState:UIControlStateNormal];
    
    _textView.text = [NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]];
}

- (void)restClient:(VdiskRestClient *)client loadedAccountInfo:(VdiskAccountInfo *)info {

    [_getAccountInfoButton setEnabled:YES];
    [_getAccountInfoButton setTitle:@"Get account info" forState:UIControlStateNormal];
    
    _textView.text = [NSString stringWithFormat:@"Success!!\n----------------\nuid:%@\nsina_uid:%@\nquota.total:%@\nquota.consumed:%@\n----------------", info.userId, info.sinaUserId, [VdiskRestClient humanReadableSize:info.quota.totalBytes], [VdiskRestClient humanReadableSize:info.quota.consumedBytes]];
}


@end
