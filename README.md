VdiskSDK-iOS
============

```objective-c

VdiskSession *session = [[VdiskSession alloc] initWithAppKey:@"你的微盘AppKey" appSecret:@"你的微盘AppSecret" appRoot:@"sandbox"];
session.delegate = self;
[session setRedirectURI:@"http://OAuth2回调地址"];
[session setRootViewController:_loginViewController];
[VdiskSession setSharedSession:[session autorelease]];

```
