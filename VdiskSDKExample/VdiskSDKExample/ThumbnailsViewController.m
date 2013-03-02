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

#import "ThumbnailsViewController.h"
#import "VdiskSDK.h"

@interface ThumbnailsViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation ThumbnailsViewController

@synthesize loadThumbButton = _loadThumbButton;
@synthesize filePathTextField = _filePathTextField;
@synthesize imageView = _imageView;

- (void)dealloc {

    [_filePathTextField release];
    [_loadThumbButton release];
    [_imageView release];
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Thumbnails";
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (IBAction)onLoadThumbButtonPressed:(id)sender {

    if ([_filePathTextField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty path" message:@"Please input the file path" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
        return;
    }
    
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], [_filePathTextField.text lastPathComponent]];
    
    
    [_vdiskRestClient loadThumbnail:_filePathTextField.text ofSize:@"s" intoPath:tmpPath];
    
    [_loadThumbButton setEnabled:NO];
    [_loadThumbButton setTitle:@"Loading" forState:UIControlStateNormal];
}

#pragma mark - VdiskRestClientDelegate


- (void)restClient:(VdiskRestClient *)client loadedThumbnail:(NSString *)destPath {

    [_loadThumbButton setEnabled:YES];
    [_loadThumbButton setTitle:@"Load thumbnail" forState:UIControlStateNormal];
    
    [_imageView setImage:[UIImage imageWithContentsOfFile:destPath]];
    
}

- (void)restClient:(VdiskRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(VdiskMetadata *)metadata {

    [_loadThumbButton setEnabled:YES];
    [_loadThumbButton setTitle:@"Load thumbnail" forState:UIControlStateNormal];
    
    [_imageView setImage:[UIImage imageWithContentsOfFile:destPath]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load metadata success!" message:@"Please check the metadata object" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client loadThumbnailFailedWithError:(NSError *)error {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_loadThumbButton setEnabled:YES];
    [_loadThumbButton setTitle:@"Load thumbnail" forState:UIControlStateNormal];
}


@end
