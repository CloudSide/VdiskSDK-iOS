//
//  SharesViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SharesViewController.h"
#import "VdiskSDK.h"

@interface SharesViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation SharesViewController

@synthesize filePathTextField = _filePathTextField;
@synthesize createLinkButton = _createLinkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_filePathTextField release];
    [_createLinkButton release];
    
    [super dealloc];
}

- (IBAction)onCreateLinkButtonPressed:(id)sender {
    
    [_createLinkButton setEnabled:NO];
    [_createLinkButton setTitle:@"Creating..." forState:UIControlStateNormal];
    
    [_filePathTextField resignFirstResponder];
    NSString *filePath = _filePathTextField.text;
    [_vdiskRestClient loadSharableLinkForFile:filePath];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)restClient loadedSharableLink:(NSString *)link forFile:(NSString *)path {
    
    [_createLinkButton setEnabled:YES];
    [_createLinkButton setTitle:@"Create share link." forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:link delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    
    [alertView show];
    [alertView release];
}

- (void)restClient:(VdiskRestClient *)restClient loadSharableLinkFailedWithError:(NSError *)error {
    
    [_createLinkButton setEnabled:YES];
    [_createLinkButton setTitle:@"Create share link" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
    }
}

@end
