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

#import "CopyRefViewController.h"
#import "VdiskSDK.h"

@interface CopyRefViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation CopyRefViewController

@synthesize filePathTextField = _filePathTextField;
@synthesize createButton = _createButton;

- (void)dealloc {

    [_filePathTextField release];
    [_createButton release];
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Create a copy_ref";
    }
    
    return self;
}

- (IBAction)onCreateButtonPressed:(id)sender {

    [_createButton setEnabled:NO];
    [_createButton setTitle:@"Creating..." forState:UIControlStateNormal];
    
    [_filePathTextField resignFirstResponder];
    NSString *filePath = _filePathTextField.text;
    [_vdiskRestClient createCopyRef:filePath];

}


#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)restClient createdCopyRef:(NSString *)copyRef {
    
    [_createButton setEnabled:YES];
    [_createButton setTitle:@"Create copy_ref" forState:UIControlStateNormal];
    
    [[UIPasteboard generalPasteboard] setString:copyRef]; 
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Created!" message:[NSString stringWithFormat:@"copy_ref:%@\nhave been saved in your clipboard", copyRef] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)restClient createCopyRefFailedWithError:(NSError *)error {
    
    [_createButton setEnabled:YES];
    [_createButton setTitle:@"Create copy_ref" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}


@end
