//
//  RestoreViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RestoreViewController.h"
#import "VdiskSDK.h"

@interface RestoreViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation RestoreViewController

@synthesize filePathTextField = _filePathTextField;
@synthesize versionTextField = _versionTextField;
@synthesize restoreButton = _restoreButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Restore";
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_filePathTextField release];
    [_versionTextField release];
    [_restoreButton release];
    
    [super dealloc];
}

- (IBAction)onRestoreButtonPressed:(id)sender {
    
    [_restoreButton setEnabled:NO];
    [_restoreButton setTitle:@"Restoring..." forState:UIControlStateNormal];
    
    [_filePathTextField resignFirstResponder];
    [_versionTextField resignFirstResponder];
    NSString *filePath = _filePathTextField.text;
    NSString *version = _versionTextField.text;
    [_vdiskRestClient restoreFile:filePath toRev:version];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client restoredFile:(VdiskMetadata *)fileMetadata {
    
    [_restoreButton setEnabled:YES];
    [_restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Restore success!" message:@"Please check the VdiskMetadata object returned by success delegate" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client restoreFileFailedWithError:(NSError *)error {
    
    [_restoreButton setEnabled:YES];
    [_restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
