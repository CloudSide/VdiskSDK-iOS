//
//  UploadBigFileViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-8-13.
//
//

#import "UploadBigFileViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UploadBigFileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, VdiskRestClientDelegate> {
    
    VdiskComplexUpload *_vdiskComplexUpload;
}

@end

@implementation UploadBigFileViewController

@synthesize progressView = _progressView;
@synthesize progressLabel = _progressLabel;
@synthesize imagePickerController = _imagePickerController;
@synthesize uploadButton = _uploadButton;
@synthesize destPath = _destPath;

- (UIImagePickerController *)imagePickerController {
    
    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        _imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    return _imagePickerController;
}

- (IBAction)onUploadButtonPressed:(id)sender {
    
    if (_destPath) {
        
        [_vdiskComplexUpload cancel];
        self.destPath = nil;
        
        _progressLabel.text = @"0.0%";
        _progressView.progress = 0.0f;
        [_uploadButton setTitle:@"Select Big File to Upload" forState:UIControlStateNormal];
        return;
    }
    [self.navigationController presentModalViewController:self.imagePickerController animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Upload big files";
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskComplexUpload cancel];
    [_vdiskComplexUpload release];
    [_destPath release];
    
    [_progressView release];
    [_progressLabel release];
    [_imagePickerController release];
    
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_progressLabel setHidden:YES];
    [_progressView setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
            
            _progressLabel.text = @"0.0%";
            _progressView.progress = 0.0f;
            [_progressLabel setHidden:NO];
            [_progressView setHidden:NO];
            
            self.destPath = [NSString stringWithFormat:@"/%@", fileName];
            [_uploadButton setTitle:@"Cancel Upload" forState:UIControlStateNormal];
            
            [_vdiskComplexUpload cancel];
            [_vdiskComplexUpload release], _vdiskComplexUpload = nil;
            
            _vdiskComplexUpload = [[VdiskComplexUpload alloc] initWithFile:fileName fromPath:tmpPath toPath:@"/"];
            _vdiskComplexUpload.delegate = self;
                        
            [_vdiskComplexUpload start:NO params:nil];
            
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
    picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - VdiskComplexUploadDelegate

- (void)complexUpload:(VdiskComplexUpload *)complexUpload startedWithStatus:(kVdiskComplexUploadStatus)status destPath:(NSString *)destPath srcPath:(NSString *)srcPath {

    switch (status) {
                        
        case kVdiskComplexUploadStatusLocateHost:
            NSLog(@"kVdiskComplexUploadStatusLocateHost");
            break;
        case kVdiskComplexUploadStatusCreateFileSHA1:
            NSLog(@"kVdiskComplexUploadStatusCreateFileSHA1");
            break;
        case kVdiskComplexUploadStatusInitialize:
            NSLog(@"kVdiskComplexUploadStatusInitialize:%@", _vdiskComplexUpload.fileSHA1);
            break;
        case kVdiskComplexUploadStatusSigning:
            NSLog(@"kVdiskComplexUploadStatusSigning");
            break;
        case kVdiskComplexUploadStatusCreateFileMD5s:
            NSLog(@"kVdiskComplexUploadStatusCreateFileMD5s");
            break;
        case kVdiskComplexUploadStatusUploading:
            NSLog(@"kVdiskComplexUploadStatusUploading:%d", _vdiskComplexUpload.pointer);
            break;
        case kVdiskComplexUploadStatusMerging:
            NSLog(@"kVdiskComplexUploadStatusMerging");
            break;
        default:
            break;
    }
    
    if (status == kVdiskComplexUploadStatusUploading) {
        
        [_progressLabel setHidden:NO];
        [_progressView setHidden:NO];
    }
}

- (void)complexUpload:(VdiskComplexUpload *)complexUpload finishedWithMetadata:(VdiskMetadata *)metadata destPath:(NSString *)destPath srcPath:(NSString *)srcPath {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Upload success!" message:@"Please look at the metadata object" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    self.destPath = nil;
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select Big File to Upload" forState:UIControlStateNormal];
    
    //delete tmp file
    [[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
}



- (void)complexUpload:(VdiskComplexUpload *)complexUpload updateProgress:(CGFloat)newProgress destPath:(NSString *)destPath srcPath:(NSString *)srcPath {

    [_progressLabel setHidden:NO];
    [_progressView setHidden:NO];
    
    [_progressView setProgress:newProgress];
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", newProgress*100.0f];
}

- (void)complexUpload:(VdiskComplexUpload *)complexUpload failedWithError:(NSError *)error destPath:(NSString *)destPath srcPath:(NSString *)srcPath {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    self.destPath = nil;
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select Big File to Upload" forState:UIControlStateNormal];
    
    //delete tmp file
    [[NSFileManager defaultManager] removeItemAtPath:[error.userInfo objectForKey:@"sourcePath"] error:nil];
}


@end
