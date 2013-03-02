//
//  MoveViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoveViewController.h"
#import "VdiskSDK.h"

@interface MoveViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation MoveViewController

@synthesize sourcePathTextField = _sourcePathTextField;
@synthesize destinationPathTextField = _destinationPathTextField;
@synthesize moveButton = _moveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Move";
    }
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_sourcePathTextField release];
    [_destinationPathTextField release];
    [_moveButton release];
    
    [super dealloc];
}

- (IBAction)onMoveButtonPressed:(id)sender {
    
    [_moveButton setEnabled:NO];
    [_moveButton setTitle:@"Moving..." forState:UIControlStateNormal];
    
    [_sourcePathTextField resignFirstResponder];
    [_destinationPathTextField resignFirstResponder];
    NSString *sourcePath = _sourcePathTextField.text;
    NSString *destPath = _destinationPathTextField.text;
    [_vdiskRestClient moveFrom:sourcePath toPath:destPath];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client movedPath:(NSString *)from_path to:(VdiskMetadata *)result {
    
    [_moveButton setEnabled:YES];
    [_moveButton setTitle:@"Move" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Move success!" message:@"Please check the VdiskMetadata object returned by success delegate" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client movePathFailedWithError:(NSError *)error {
    
    [_moveButton setEnabled:YES];
    [_moveButton setTitle:@"Move" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
