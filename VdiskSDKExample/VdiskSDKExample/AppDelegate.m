//
//  VdiskSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Bruce Chen (weibo: @一个开发者) on 12-6-15.
//
//  Copyright (c) 2012 Sina Vdisk. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "VdiskSDK.h"
#import "CatalogViewController.h"

/*

#define kVdiskSDKDemoAppKey             @"Vdisk AppKey"
#define kVdiskSDKDemoAppSecret          @"Vdisk AppSecret"
#define kVdiskSDKDemoAppRedirectURI     @"Vdisk RedirectURI"

#define kWeiboAppKey                    @"Weibo AppKey"
#define kWeiboAppSecret                 @"Weibo AppSecret"
#define kWeiboAppRedirectURI            @"Weibo RedirectURI"
 
*/


#ifndef kVdiskSDKDemoAppKey
    #error
#endif

#ifndef kVdiskSDKDemoAppRedirectURI
    #error
#endif

#ifndef kVdiskSDKDemoAppSecret
    #error
#endif

#ifndef kWeiboAppKey
    #error
#endif

#ifndef kWeiboAppSecret
    #error
#endif

#ifndef kWeiboAppRedirectURI
    #error
#endif

@interface AppDelegate () <VdiskSessionDelegate, VdiskNetworkRequestDelegate>

@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize catalogNavigationController = _catalogNavigationController;
//@synthesize weiboAccessToken = _weiboAccessToken;

- (void)dealloc {
    
    [_window release];
    [_navigationController release];
    [_catalogNavigationController release];
    //[_weiboAccessToken release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //if use weibo access token
    //self.weiboAccessToken = @"2.00nIvFoBR8VVWB72dcdbe20eR7UhCC";
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    RootViewController *rootViewController = [[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil] autorelease];
    rootViewController.title = @"Link Vdisk";
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    SinaWeibo *sinaWeibo = [[[SinaWeibo alloc] initWithAppKey:kWeiboAppKey appSecret:kWeiboAppSecret appRedirectURI:kWeiboAppRedirectURI andDelegate:rootViewController] autorelease];
    
    VdiskSession *session = [[VdiskSession alloc] initWithAppKey:kVdiskSDKDemoAppKey appSecret:kVdiskSDKDemoAppSecret appRoot:@"basic" sinaWeibo:sinaWeibo];
	session.delegate = self;
    //[session setRedirectURI:@"http://vauth.appsina.com"];
    [session setRedirectURI:kVdiskSDKDemoAppRedirectURI];
    //session.udid = [[UIDevice currentDevice] uniqueIdentifier];
	[VdiskSession setSharedSession:session];
    [session release];
	[VdiskComplexRequest setNetworkRequestDelegate:self];
    
    if ([session isLinked]) {
        
        //[session refreshLink];
        [_navigationController presentModalViewController:self.catalogNavigationController animated:NO];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[VdiskSession sharedSession].sinaWeibo applicationDidBecomeActive];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[VdiskSession sharedSession].sinaWeibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[VdiskSession sharedSession].sinaWeibo handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CatalogNavigationController

- (UINavigationController *)catalogNavigationController {

    if (!_catalogNavigationController) {
        
        CatalogViewController *catalogViewController = [[[CatalogViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        _catalogNavigationController = [[UINavigationController alloc] initWithRootViewController:catalogViewController];
    }
    
    return _catalogNavigationController;
}

#pragma mark -
#pragma mark VdiskNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
    
	outstandingRequests++;
	
    if (outstandingRequests == 1) {
	
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	
    outstandingRequests--;
	
    if (outstandingRequests == 0) {
	
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

#pragma mark -
#pragma mark VdiskSessionDelegate methods

- (void)sessionAlreadyLinked:(VdiskSession *)session {

    NSLog(@"sessionAlreadyLinked");
}

// Log in successfully.
- (void)sessionLinkedSuccess:(VdiskSession *)session {

    /*
    VdiskRestClient *restClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
    [restClient loadAccountInfo];
    */
     
    NSLog(@"sessionLinkedSuccess");
    
    @try {
        
        [_navigationController presentModalViewController:self.catalogNavigationController animated:YES];
    
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception);
    
    } @finally {
        
        
    }
    
}

//log fail
- (void)session:(VdiskSession *)session didFailToLinkWithError:(NSError *)error {

    NSLog(@"didFailToLinkWithError:%@", error);
}

// Log out successfully.
- (void)sessionUnlinkedSuccess:(VdiskSession *)session {

    NSLog(@"sessionUnlinkedSuccess");
    [self.catalogNavigationController dismissModalViewControllerAnimated:YES];
}

// When you use the VdiskSession's request methods,
// you may receive the following four callbacks.
- (void)sessionNotLink:(VdiskSession *)session {

    [self.catalogNavigationController dismissModalViewControllerAnimated:YES];
    NSLog(@"sessionNotLink");
}


- (void)sessionExpired:(VdiskSession *)session {
    
    //[self.catalogNavigationController dismissModalViewControllerAnimated:YES];
    /*
    [[VdiskSession sharedSession] refreshLink];
     */
    NSLog(@"sessionExpired");
    [session refreshLink];
}

/*

- (void)sessionWeiboAccessTokenIsNull:(VdiskSession *)session {

    NSLog(@"sessionWeiboAccessTokenIsNull");
    
    [session setWeiboAccessToken:_weiboAccessToken];
    [session link];
}
 
 */

@end
