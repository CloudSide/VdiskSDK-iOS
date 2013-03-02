//
//  ShareFileToFriendsViewController.m
//  VdiskSDKExample
//
//  Created by Bruce on 13-1-7.
//
//

#import "ShareFileToFriendsViewController.h"
#import "VdiskSDK.h"


@interface ShareFileToFriendsViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_client;
}

@end

@implementation ShareFileToFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _client = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_client setDelegate:self];
    }
    
    return self;
}

- (void)dealloc {

    [_client cancelAllRequests];
    [_client release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"ShareFileToFriend";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {

    [_client createCopyRef:@"/12/12/1.jpg" toFriends:@[@"1656360925", @"2162653704"]];
}

- (IBAction)button2Pressed:(id)sender {
        
    [_client createCopyRefAndAccessCode:@"/12/12/1.jpg"];
}

- (IBAction)button3Pressed:(id)sender {

    /*
     copyRef:6V8pP5YOEEu
     accessCode:T2C9
     link:http://vdisk.weibo.com/lc/6V8pP5YOEEu
     */
    
    [_client loadSharesMetadata:@"6V8pP5YOEEu" withAccessCode:@"T2C9"];
}

- (IBAction)button4Pressed:(id)sender {

    [_client loadSharesMetadataFromMyFriend:@"6V8pP5YOEEu"];
}

- (IBAction)button5Pressed:(id)sender {

    [_client copyFromRef:@"6V8pP5YOEEu" toPath:@"/12/ada.jpg" withAccessCode:@"T2C9"];
}

- (IBAction)button6Pressed:(id)sender {

    [_client copyFromMyFriendRef:@"6V8pP5YOEEu" toPath:@"/12/12.pp"];
}


#pragma - mark VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client copiedFromMyFriendRef:(NSString *)copyRef to:(VdiskMetadata *)to {
    
    NSLog(@"copyRef:%@", copyRef);
    
    NSLog(@"filename:%@", to.filename);
    NSLog(@"path:%@", to.path);
    NSLog(@"fileMd5:%@", to.fileMd5);
    NSLog(@"fileSha1:%@", to.fileSha1);
    NSLog(@"humanReadableSize:%@", to.humanReadableSize);
}

- (void)restClient:(VdiskRestClient *)client copyFromMyFriendRefFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client copiedRef:(NSString *)copyRef accessCode:(NSString *)accessCode to:(VdiskMetadata *)to {

    NSLog(@"copyRef:%@", copyRef);
    NSLog(@"accessCode:%@", accessCode);
    
    NSLog(@"filename:%@", to.filename);
    NSLog(@"path:%@", to.path);
    NSLog(@"fileMd5:%@", to.fileMd5);
    NSLog(@"fileSha1:%@", to.fileSha1);
    NSLog(@"humanReadableSize:%@", to.humanReadableSize);
}

- (void)restClient:(VdiskRestClient *)client copyFromRefWithAccessCodeFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadedSharesMetadataFromMyFriend:(VdiskSharesMetadata *)metadata {

    NSLog(@"name:%@", metadata.name);
    NSLog(@"url:%@", metadata.url);
    NSLog(@"link:%@", metadata.link);
    NSLog(@"fileMd5:%@", metadata.fileMd5);
    NSLog(@"fileSha1:%@", metadata.fileSha1);
    NSLog(@"humanReadableSize:%@", metadata.humanReadableSize);
    NSLog(@"sinaUid:%@", metadata.sinaUid);
    NSLog(@"uid:%@", metadata.uid);
    
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], metadata.filename];
    [_client loadFileWithSharesMetadata:metadata intoPath:tmpPath];
}

- (void)restClient:(VdiskRestClient *)client loadSharesMetadataFromMyFriendFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadedSharesMetadataWithAccessCode:(VdiskSharesMetadata *)metadata {

    NSLog(@"name:%@", metadata.name);
    NSLog(@"url:%@", metadata.url);
    NSLog(@"link:%@", metadata.link);
    NSLog(@"fileMd5:%@", metadata.fileMd5);
    NSLog(@"fileSha1:%@", metadata.fileSha1);
    NSLog(@"humanReadableSize:%@", metadata.humanReadableSize);
    NSLog(@"sinaUid:%@", metadata.sinaUid);
    NSLog(@"uid:%@", metadata.uid);
    
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], metadata.filename];
    [_client loadFileWithSharesMetadata:metadata intoPath:tmpPath];
}

- (void)restClient:(VdiskRestClient *)client loadSharesMetadataWithAccessCodeFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client createdCopyRef:(NSString *)copyRef toFriends:(NSArray *)friends link:(NSString *)link {

    NSLog(@"copyRef:%@", copyRef);
    NSLog(@"toFriends:%@", friends);
    NSLog(@"link:%@", link);
}

- (void)restClient:(VdiskRestClient *)client createCopyRefToFriendsFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client createdCopyRef:(NSString *)copyRef accessCode:(NSString *)accessCode link:(NSString *)link {

    NSLog(@"copyRef:%@", copyRef);
    NSLog(@"accessCode:%@", accessCode);
    NSLog(@"link:%@", link);
}


- (void)restClient:(VdiskRestClient *)client createCopyRefAndAccessCodeFailedWithError:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadFileFailedWithError:(NSError *)error sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {

    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadedFile:(NSString *)destPath sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {

    NSLog(@"%@ : %@", sharesMetadata.filename, destPath);
}

- (void)restClient:(VdiskRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {

    NSLog(@"%@ : %f%%", sharesMetadata.filename, progress * 100);
}

@end
