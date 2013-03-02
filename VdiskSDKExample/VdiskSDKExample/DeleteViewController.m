//
//  DeleteViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeleteViewController.h"
#import "VdiskSDK.h"

@interface DeleteViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation DeleteViewController

@synthesize deletePathTextField = _deletePathTextField;
@synthesize deleteButton = _deleteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.title = @"Delete";
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_deletePathTextField release];
    [_deleteButton release];
    
    [super dealloc];
}

- (IBAction)onDeleteButtonPressed:(id)sender {
    
    [_deleteButton setEnabled:NO];
    [_deleteButton setTitle:@"Deleting..." forState:UIControlStateNormal];
    
    [_deletePathTextField resignFirstResponder];
    NSString *filePath = _deletePathTextField.text;
    [_vdiskRestClient deletePath:filePath];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)client deletedPath:(NSString *)path {
    
    [_deleteButton setEnabled:YES];
    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Delete Success!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)client deletePathFailedWithError:(NSError *)error {
    
    [_deleteButton setEnabled:YES];
    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
