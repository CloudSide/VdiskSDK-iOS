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

#import "CopyFromCopyRefViewController.h"
#import "VdiskSDK.h"

@interface CopyFromCopyRefViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation CopyFromCopyRefViewController

@synthesize theCopyRefTextField = _theCopyRefTextField;
@synthesize destinationPathTextField = _destinationPathTextField;
@synthesize theCopyButton = _theCopyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Copy From CopyRef";
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_theCopyRefTextField release];
    [_destinationPathTextField release];
    [_theCopyButton release];
    
    [super dealloc];
}

- (IBAction)onCopyButtonPressed:(id)sender {
    
    [_theCopyButton setEnabled:NO];
    [_theCopyButton setTitle:@"Copying..." forState:UIControlStateNormal];
    
    [_theCopyRefTextField resignFirstResponder];
    [_destinationPathTextField resignFirstResponder];

    [_vdiskRestClient copyFromRef:_theCopyRefTextField.text toPath:_destinationPathTextField.text];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client copiedRef:(NSString *)copyRef to:(VdiskMetadata *)to {
    
    [_theCopyButton setEnabled:YES];
    [_theCopyButton setTitle:@"Copy" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Copy success!" message:@"Please check the VdiskMetadata object returned by success delegate" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client copyFromRefFailedWithError:(NSError *)error {
    
    [_theCopyButton setEnabled:YES];
    [_theCopyButton setTitle:@"Copy" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
