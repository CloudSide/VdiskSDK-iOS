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

#import "MediaFilesFromRefViewController.h"
#import "VdiskSDK.h"
#import <MediaPlayer/MediaPlayer.h>


@interface MediaFilesFromRefViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
    MPMoviePlayerController *_player;
}

@end

@implementation MediaFilesFromRefViewController

@synthesize loadFileButton = _loadFileButton;
@synthesize theCopyRefTextField = _theCopyRefTextField;

- (void)dealloc {
    
    [_loadFileButton release];
    [_theCopyRefTextField release];
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_player stop];
	[_player release];
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Media files from ref";
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _player = [[MPMoviePlayerController alloc] init];
	[[_player view] setFrame:CGRectMake(10.0, 80.0, 300.0, 300.0)];
	[self.view addSubview: [_player view]];
    [_player.view setBackgroundColor:[UIColor clearColor]];
    [_player.view setHidden:YES];
}

- (IBAction)onLoadFileButtonPressed:(id)sender {
    
    if ([_theCopyRefTextField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty path" message:@"Please input the file path" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
        return;
    }
    
    [_vdiskRestClient loadStreamableURLFromRef:_theCopyRefTextField.text];
    [_loadFileButton setEnabled:NO];
    [_loadFileButton setTitle:@"Loading" forState:UIControlStateNormal];
}


#pragma mark - VdiskRestClientDelegate


- (void)restClient:(VdiskRestClient *)client loadStreamableURLFromRefFailedWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_loadFileButton setEnabled:YES];
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    
}

- (void)restClient:(VdiskRestClient *)client loadedStreamableURL:(NSURL *)url fromRef:(NSString *)copyRef {
    
    [_theCopyRefTextField resignFirstResponder];
    
    [_loadFileButton setEnabled:YES];
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    
    [_player stop];
    [_player.view setHidden:NO];
	[_player setContentURL:url];
	[_player play];    
}

@end
