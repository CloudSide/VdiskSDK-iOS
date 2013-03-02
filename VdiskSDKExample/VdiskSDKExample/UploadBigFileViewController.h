//
//  UploadBigFileViewController.h
//  VdiskSDKExample
//
//  Created by gaopeng on 12-8-13.
//
//

#import <UIKit/UIKit.h>
#import "VdiskComplexUpload.h"

@interface UploadBigFileViewController : UIViewController <VdiskComplexUploadDelegate>

@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSString *destPath;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;

- (IBAction)onUploadButtonPressed:(id)sender;

@end
