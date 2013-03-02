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

#import "LoadFileViewController.h"
#import "VdiskSDK.h"

@interface LoadFileViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
    BOOL _isExecuting;
}

@end

@implementation LoadFileViewController

@synthesize progressView = _progressView;
@synthesize progressLabel = _progressLabel;
@synthesize loadFileButton = _loadFileButton;
@synthesize filePathTextField = _filePathTextField;

- (void)dealloc {

    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_progressView release];
    [_progressLabel release];
    [_loadFileButton release];
    [_filePathTextField release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Load files";
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        _vdiskRestClient.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_progressLabel setHidden:YES];
    [_progressView setHidden:YES];
}


- (IBAction)onLoadFileButtonPressed:(id)sender {
    
    if ([_filePathTextField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty path" message:@"Please input the file path" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
        return;
    }
    
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], [_filePathTextField.text lastPathComponent]];
        
    if (!_isExecuting) {
        
         [_vdiskRestClient loadFile:_filePathTextField.text intoPath:tmpPath];
        //[_loadFileButton setEnabled:NO];
        [_loadFileButton setTitle:@"Cancel" forState:UIControlStateNormal];
        _isExecuting = YES;
        
    } else {
        
        [_vdiskRestClient cancelFileLoad:_filePathTextField.text];
        [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
        _isExecuting = NO;
        
        [_progressLabel setHidden:YES];
        [_progressView setHidden:YES];
        
        [_progressView setProgress:0.0f];
        [_progressLabel setText:@"0.0%"];
    }
    
}


#pragma mark - VdiskRestClientDelegate

/*
 
 The following two methods, to implements any one method
 
 */

- (void)restClient:(VdiskRestClient *)client loadedFile:(NSString *)destPath {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load success!" message:[NSString stringWithFormat:@"Please check the Path: %@", destPath] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    //[_loadFileButton setEnabled:YES];
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    _isExecuting = NO;
}


- (void)restClient:(VdiskRestClient *)client loadedFile:(NSString *)destPath contentType:(NSString *)contentType metadata:(VdiskMetadata *)metadata {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load metadata success!" message:@"Please check the metadata object" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    //[_loadFileButton setEnabled:YES];
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    _isExecuting = NO;
}


- (void)restClient:(VdiskRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath {

    [_progressLabel setHidden:NO];
    [_progressView setHidden:NO];
    
    [_progressView setProgress:progress];
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress*100.0f];
}


- (void)restClient:(VdiskRestClient *)client loadFileFailedWithError:(NSError *)error {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    //[_loadFileButton setEnabled:YES];
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    _isExecuting = NO;
}


- (BOOL)restClient:(VdiskRestClient *)client loadedFileRealDownloadURL:(NSURL *)realDownloadURL metadata:(VdiskMetadata *)metadata {

    return YES;
    
    [_loadFileButton setTitle:@"Load file" forState:UIControlStateNormal];
    _isExecuting = NO;
    
    //Get the real download url
    NSLog(@"%@\n%@", realDownloadURL, metadata);
    
    /*
    [[UIApplication sharedApplication] openURL:realDownloadURL];
    return NO;
    */
    
    //if return no, will cancel the download, only get the real download url and metadata
    return NO;
}

@end
