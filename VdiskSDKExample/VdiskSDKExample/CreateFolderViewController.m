//
//  CreateFolderViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreateFolderViewController.h"
#import "VdiskSDK.h"

@interface CreateFolderViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation CreateFolderViewController

@synthesize folderNameTextField = _folderNameTextField;
@synthesize createFolderButton = _createFolderButton;
@synthesize parentPath = _parentPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Cretate folder";
    }
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_folderNameTextField release];
    [_createFolderButton release];
    
    [super dealloc];
}

- (IBAction)onCreateFolderButtonPressed:(id)sender {
    
    [_createFolderButton setEnabled:NO];
    [_createFolderButton setTitle:@"Creating..." forState:UIControlStateNormal];
    
    [_folderNameTextField resignFirstResponder];
    NSString *filePath = _folderNameTextField.text;
    [_vdiskRestClient createFolder:filePath];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client createdFolder:(VdiskMetadata *)folder {
    
    [_createFolderButton setEnabled:YES];
    [_createFolderButton setTitle:@"Create folder" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create success!" message:@"Please check the VdiskMetadata object returned by success delegate" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client createFolderFailedWithError:(NSError *)error {
    
    [_createFolderButton setEnabled:YES];
    [_createFolderButton setTitle:@"Create folder" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
