VdiskSDK-iOS
============
RESTful API文档地址:
http://vdisk.weibo.com/developers/index.php?module=api&action=apidoc
============

包含头文件: VdiskSDK.h

============

实例化VdiskSession

```objective-c

VdiskSession *session = [[VdiskSession alloc] initWithAppKey:@"你的微盘AppKey" appSecret:@"你的微盘AppSecret" appRoot:@"sandbox"];
session.delegate = self;
[session setRedirectURI:@"http://OAuth2回调地址"];
[session setRootViewController:_loginViewController];
[VdiskSession setSharedSession:[session autorelease]];

```

判断是否已登录

```objective-c
[[VdiskSession sharedSession] isLinked];
```

授权并登录

```objective-c
[[VdiskSession sharedSession] link];
```

=============

上传文件

1. 实例化VdiskRestClient

```objective-c

_vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
_vdiskRestClient.delegate = self;

```

2. 调用上传方法

```objective-c

[_vdiskRestClient uploadFile:@"要保存的文件名" toPath:@"目标路径(不含文件名)" withParentRev:nil fromPath:@"本地文件全路径"];

```
3. 实现Delegate

```objective-c

#pragma mark - VdiskRestClientDelegate

//处理上传成功后的工作
- (void)restClient:(VdiskRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(VdiskMetadata *)metadata {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Upload success!" message:@"Please look at the metadata object" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select a photo to upload" forState:UIControlStateNormal];
    
    //delete tmp file, 如果有必要的话
    [[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
}

//更新进度
- (void)restClient:(VdiskRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath {

    [_progressLabel setHidden:NO];
    [_progressView setHidden:NO];
    
    [_progressView setProgress:progress];
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress*100.0f];
}

//处理上传失败后的工作
- (void)restClient:(VdiskRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_uploadButton setEnabled:YES];
    [_uploadButton setTitle:@"Select a photo to upload" forState:UIControlStateNormal];
       
    //delete tmp file, 如果有必要的话
    [[NSFileManager defaultManager] removeItemAtPath:[error.userInfo objectForKey:@"sourcePath"] error:nil];
}

```



