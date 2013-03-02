VdiskSDK-iOS
============
RESTful API文档地址:
http://vdisk.weibo.com/developers/index.php?module=api&action=apidoc
============

包含头文件: VdiskSDK.h

============

```objective-c

VdiskSession *session = [[VdiskSession alloc] initWithAppKey:@"你的微盘AppKey" appSecret:@"你的微盘AppSecret" appRoot:@"sandbox"];
session.delegate = self;
[session setRedirectURI:@"http://OAuth2回调地址"];
[session setRootViewController:_loginViewController];
[VdiskSession setSharedSession:[session autorelease]];

```
