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

#import "VdiskAccountInfo.h"


@implementation VdiskAccountInfo


@synthesize quota = _quota;
@synthesize userId = _userId;
@synthesize sinaUserId = _sinaUserId;


- (id)initWithDictionary:(NSDictionary *)dict {
    
    
    if ((self = [super init])) {
    
        
        if ([dict objectForKey:@"quota_info"]) {
        
            _quota = [[VdiskQuota alloc] initWithDictionary:[dict objectForKey:@"quota_info"]];
        }
        
        
        
        if ([[dict objectForKey:@"uid"] isKindOfClass:[NSNumber class]]) {
            
            _userId = [[[dict objectForKey:@"uid"] stringValue] retain];
            
        } else {
            
            _userId = [[dict objectForKey:@"uid"] retain];
        }
        
        if ([[dict objectForKey:@"sina_uid"] isKindOfClass:[NSNumber class]]) {
            
            _sinaUserId = [[[dict objectForKey:@"sina_uid"] stringValue] retain];
            
        } else {
            
            _sinaUserId = [[dict objectForKey:@"sina_uid"] retain];
        }
        
       
        _original = [dict retain];
    }
    
    return self;
}

- (void)dealloc {
    
    [_quota release];
    [_userId release];
    [_sinaUserId release];
    [_original release];
    
    [super dealloc];
}




#pragma mark NSCoding methods

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:_original forKey:@"original"];
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if ([coder containsValueForKey:@"original"]) {
    
        return [self initWithDictionary:[coder decodeObjectForKey:@"original"]];
    
    } else {
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

        VdiskQuota *tempQuota = [coder decodeObjectForKey:@"quota"];
        
        NSDictionary *quotaDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:tempQuota.consumedBytes], @"consumed", [NSNumber numberWithLongLong:tempQuota.totalBytes], @"quota", nil];
        
        [mDict setObject:quotaDict forKey:@"quota_info"];

        NSNumber *uid = [NSNumber numberWithLongLong:[[coder decodeObjectForKey:@"userId"] longLongValue]];
        NSNumber *sinaUid = [NSNumber numberWithLongLong:[[coder decodeObjectForKey:@"sinaUserId"] longLongValue]];
        
        [mDict setObject:uid forKey:@"uid"];
        [mDict setObject:sinaUid forKey:@"sina_uid"];
        

        return [self initWithDictionary:mDict];
    }
}

@end
