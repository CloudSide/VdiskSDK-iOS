//
//  CopyViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CopyViewController.h"
#import "VdiskSDK.h"

@interface CopyViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation CopyViewController

@synthesize sourcePathTextField = _sourcePathTextField;
@synthesize destinationPathTextField = _destinationPathTextField;
@synthesize aCopButton = _aCopButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Copy";
    }
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_sourcePathTextField release];
    [_destinationPathTextField release];
    [_aCopButton release];
    
    [super dealloc];
}

- (IBAction)onCopyButtonPressed:(id)sender {
    
    [_aCopButton setEnabled:NO];
    [_aCopButton setTitle:@"Copying..." forState:UIControlStateNormal];
    
    [_sourcePathTextField resignFirstResponder];
    [_destinationPathTextField resignFirstResponder];
    NSString *sourcePath = _sourcePathTextField.text;
    NSString *destPath = _destinationPathTextField.text;
    [_vdiskRestClient copyFrom:sourcePath toPath:destPath];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client copiedPath:(NSString *)fromPath to:(VdiskMetadata *)to {
    
    [_aCopButton setEnabled:YES];
    [_aCopButton setTitle:@"Copy" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Copy success!" message:@"Please check the VdiskMetadata object returned by success delegate" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client copyPathFailedWithError:(NSError *)error {
    
    [_aCopButton setEnabled:YES];
    [_aCopButton setTitle:@"Copy" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
