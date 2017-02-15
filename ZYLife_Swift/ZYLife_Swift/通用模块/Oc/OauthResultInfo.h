//
//  OauthResultInfo.h
//  BingoSled
//
//  Created by liang le on 14-1-24.
//  Copyright (c) 2014年 bingosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef long long MyLong;

@interface OauthResultInfo : NSObject


typedef enum
{
    // 通过
    LoginStatePass1 = 1,
    // 过期
    LoginStateTimeOut2 = 2,
    // 不正确
    LoginStateFail3 = 3,
    // 失败
    LoginStateException5 = 5,
} LoginState;

//请求是否成功
@property (nonatomic) BOOL success;

//用户账号
@property (nonatomic, retain) NSString *identity;

@property (nonatomic, retain) NSString *ex_oauth_access_token;

//过期时间
@property (nonatomic) MyLong ex_oauth_access_token_expires;

//刷新token
@property (nonatomic, retain) NSString *ex_oauth_refresh_token;

//token
@property (nonatomic, copy) NSString* ex_token;

//token过期时间
@property (nonatomic) MyLong ex_token_expires;

//出错信息
@property (nonatomic, retain) NSString * errorMessage;

//出错信息
@property (nonatomic, retain) NSString * eCode;

/**
 *  通过字典初始化返回结果
 */
- (OauthResultInfo *) initWithDictionary:(NSDictionary *)dic;

@end
