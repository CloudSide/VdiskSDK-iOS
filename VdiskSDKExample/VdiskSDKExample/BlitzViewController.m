//
//  BlitzViewController.m
//  VdiskSDKExample
//
//  Created by Bruce on 12-11-21.
//
//

#import "BlitzViewController.h"

@interface BlitzViewController () {

    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation BlitzViewController

@synthesize blitzButton = _blitzButton;

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
    [_vdiskRestClient release];
    [_blitzButton release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)blitzButtonPressed:(id)sender {

    [_vdiskRestClient blitz:@"OS X 10.8 Mountain Lion.dmg" toPath:@"/" sha1:@"e5dd2bf5560033cade7dd7d7da5ceec49f701b0e" size:4348218934];
    
    [_blitzButton setEnabled:NO];
}

#pragma - mark VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)restClient blitzedFile:(NSString *)destPath sha1:(NSString *)sha1 size:(unsigned long long)size metadata:(VdiskMetadata *)metadata {

    NSLog(@"blitzedFile:%@", destPath);
    
    [_blitzButton setEnabled:YES];
}

- (void)restClient:(VdiskRestClient *)restClient blitzFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
    
    [_blitzButton setEnabled:YES];
}



@end
