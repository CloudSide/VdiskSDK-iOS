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

#import "UploadFileViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VdiskRestClient.h"

@interface UploadFileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation UploadFileViewController

@synthesize progressView = _progressView;
@synthesize progressLabel = _progressLabel;
@synthesize imagePickerController = _imagePickerController;
@synthesize uploadButton = _uploadButton;

- (UIImagePickerController *)imagePickerController {

    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    return _imagePickerController;
}

- (IBAction)onSelectPhotoButtonPressed:(id)sender {
    
    [self.navigationController presentModalViewController:self.imagePickerController animated:YES];
}

- (void)dealloc {

    [_progressView release];
    [_progressLabel release];
    [_imagePickerController release];
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        self.title = @"Upload files";
        
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
            
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *theAsset) {
        
        NSString *fileName = [[theAsset defaultRepresentation] filename];
        NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], fileName];
                
        NSMutableData *emptyData = [[NSMutableData alloc] initWithLength:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:tmpPath contents:emptyData attributes:nil];
        [emptyData release];
        
        NSFileHandle *theFileHandle = [NSFileHandle fileHandleForWritingAtPath:tmpPath];
        
        unsigned long long offset = 0;
        unsigned long long length;
        
        long long theItemSize = [[theAsset defaultRepresentation] size];
        
        long long bufferLength = 16384;
        
        if (theItemSize > 262144) {
            
            bufferLength = 262144;
            
        } else if (theItemSize > 65536) {
            
            bufferLength = 65536;
        }
        
        NSError *err = nil;
        uint8_t *buffer = (uint8_t *)malloc(bufferLength);
        
        while ((length = [[theAsset defaultRepresentation] getBytes:buffer fromOffset:offset length:bufferLength error:&err]) > 0 && err == nil) {
            
            NSData *data = [[NSData alloc] initWithBytes:buffer length:length];
            [theFileHandle writeData:data];
            [data release];
            offset += length;
        }
        
        free(buffer);
        
        [theFileHandle closeFile];
        
        if ([fileManager fileExistsAtPath:tmpPath]) {
        
            [_vdiskRestClient uploadFile:fileName toPath:@"/" withParentRev:nil fromPath:tmpPath];
            [_uploadButton setEnabled:NO];
            [_uploadButton setTitle:@"Uploading" forState:UIControlStateNormal];
        }
    
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *theError) {
        
        NSLog(@"%@", [theError localizedDescription]);
    };
    
    
    NSURL *referenceURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:referenceURL resultBlock:resultblock failureBlock:failureblock];
    [assetslibrary release];
        
    [picker dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(VdiskMetadata *)metadata {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Upload success!" message:@"Please look at the metadata object" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select a photo to upload" forState:UIControlStateNormal];
    
    //delete tmp file
    [[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
}

- (void)restClient:(VdiskRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath {

    [_progressLabel setHidden:NO];
    [_progressView setHidden:NO];
    
    [_progressView setProgress:progress];
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress*100.0f];
}

- (void)restClient:(VdiskRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select a photo to upload" forState:UIControlStateNormal];
       
    //delete tmp file
    [[NSFileManager defaultManager] removeItemAtPath:[error.userInfo objectForKey:@"sourcePath"] error:nil];
}

@end
