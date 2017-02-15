//
//  SSOHelper.h
//  SSOTest
//
//  Created by 张 宏飞 on 12-8-21.
//  Copyright (c) 2012年 --. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OauthResultInfo.h"

/**
 *  sso认证类
 */
@interface SSOHelper : NSObject
{
	NSMutableArray	*requestArray;
	OauthResultInfo *_oauthResultInfo;
    NSString *_loginID;
}

/**
 *  根据单点服务器地址初始化实例
 */
- (id)initWithSSOUrl:(NSString*)ssoURL;

/**
 *  通过用户名和密码登录
 */
- (OauthResultInfo *)login:(NSString *)username withPassword:(NSString *)password;

/**
 *  刷新AccessToken
 */
- (BOOL)refreshAccessToken:(NSString **)errorMsg;

/**
 *  获取一次性登录ticket
 */
- (NSString*)getLoginTicket;

/**
 *  注销
 */
- (BOOL)logout;

@end

