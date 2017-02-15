//
//  SSOHelper.m
//  SSOTest
//
//  Created by 张 宏飞 on 12-8-21.
//  Copyright (c) 2012年 --. All rights reserved.
//

#import "SSOHelper.h"
#import "UserDefaults.h"

#define kNotificationBingoLinkAccessTokenUpdate @"kNotificationBingoLinkAccessTokenUpdate"

@implementation SSOHelper
{
    NSString* _ssoServer;
}

- (void)dealloc
{
    
     @synchronized(requestArray) {
         /* 清空之前的请求
         for (NSMutableURLRequest *req in requestArray) {
             [req clearDelegatesAndCancel];
         }*/
         [requestArray removeAllObjects];
     }
    
    //LOGDEALLOC();
}

- (id)init
{
    self = [super init];
    
    if (nil != self) {
        //DLog(@"%@ %d",[NSThread callStackSymbols],(int)self);
        
        @throw [[NSException alloc]initWithName:@"初始化失败！" reason:@"请使用 initWithSSOUrl构造函数初始化！" userInfo:nil];
    }
    
    return self;
}

- (id)initWithSSOUrl:(NSString*)ssoURL
{
    self = [super init];
    if (self) {
        _ssoServer = ssoURL;
        requestArray = [NSMutableArray arrayWithCapacity:8];
    }
    return self;
}

/*************************************** 地址信息 ***************************************/

//link认证地址
//NSString *link_oauth_url;
- (NSString *) link_oauth_url:(NSString *)username password:(NSString *)password
{
    NSString *link_oauth_url_template = @"%@/v2?openid.mode=checkid_setup&openid.ex.client_id=clientId&credential_type=password&openid.ex.get_spec_secret=y&openid.ex.get_oauth_access_token=y&userType=1";
    
    NSString *url = [NSString stringWithFormat:link_oauth_url_template, _ssoServer];
    
//    if (username.length > 0) {
//        url = [NSString stringWithFormat:@"%@&username=%@&password=%@",url, username, password];
//    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return url;
}

- (NSString *)login_ticket_url
{
    NSString *login_ticket_setup = @"%@/v2?openid.mode=login_ticket_setup&openid.ex.token=%@";
    
    NSString *url = [NSString stringWithFormat:login_ticket_setup, _ssoServer, [UserDefaults sharedInstance].ex_token];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return url;
}

//刷新token地址
- (NSString *)link_refresh_token_url
{
    NSString *link_refresh_token_url_template = @"%@/oauth/2/token?client_id=clientId&grant_type=refresh_token&refresh_token=%@";
    
    return [NSString stringWithFormat:link_refresh_token_url_template, _ssoServer, [UserDefaults sharedInstance].refreshToken];
}

/*************************************** 地址信息 ***************************************/

#pragma mark - SSO认证

- (OauthResultInfo *)login:(NSString *)username withPassword:(NSString *)password
{
    _loginID = username;
    
    NSHTTPCookieStorage *cookieJar	= [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray				*_tmpArray	= [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    
    //DLog(@" 0x%x %@",(int)self,[NSThread callStackSymbols]);
    NSURL *url = [NSURL URLWithString:[self link_oauth_url:username password:password]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    password = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) password,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    NSString *bodyStr = [NSString stringWithFormat:@"username=%@&password=%@",username, password];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"http.protocol.element-charset"];
    
    NSString *requestMedthd = @"POST";
    
    [request setHTTPMethod:requestMedthd];
    
    // 忽略https证书
    /*
     if ([url.absoluteString hasPrefix:@"https://"]) {
     [request setValidatesSecureCertificate:NO];
     }
     */
    
    @synchronized(requestArray) {
        
        [requestArray removeAllObjects];
        [requestArray addObject:request];
    }
    
    NSHTTPURLResponse* response = nil;
    NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString* responseString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    if (response == nil) {
        //DDLogError(@"登录返回空");
        
        _oauthResultInfo = [[OauthResultInfo alloc] init];
        _oauthResultInfo.success = NO;
        _oauthResultInfo.errorMessage = @"登录失败，请求服务器出错。";
    }
    else{
        //取出返回集合
        NSDictionary	*result	= [self getResultsFromString:responseString];
        _oauthResultInfo = [[OauthResultInfo alloc] initWithDictionary:result];
        
        if (_oauthResultInfo.success) {
            // 保存用户信息
            [UserDefaults sharedInstance].accessToken 	= _oauthResultInfo.ex_oauth_access_token;
            [UserDefaults sharedInstance].ex_token 		= _oauthResultInfo.ex_token;
            [UserDefaults sharedInstance].refreshToken 	= _oauthResultInfo.ex_oauth_refresh_token;
            [UserDefaults sharedInstance].loginID 		= _oauthResultInfo.identity;
            [UserDefaults sharedInstance].eCode 		= _oauthResultInfo.eCode;
            [UserDefaults sharedInstance].password      = password;
            [UserDefaults sharedInstance].userId        = username; //手机号
        } else {
            //失败
            _oauthResultInfo.errorMessage = @"登录失败，请求服务器出错。";
        }
    }
    
    return _oauthResultInfo;
}

/**
 *  从sso服务器返回结果中解析出信息
 *  服务器返回格式 key:value
 */
- (NSDictionary *)getResultsFromString:(NSString *)result
{
    NSArray				*arra		= [result componentsSeparatedByString:@"\n"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (arra) {
        for (int i = 0; i < arra.count - 1; i++) {
            NSArray *item = [[arra objectAtIndex:i] componentsSeparatedByString:@":"];
            
            if (item.count == 2) {
                [dictionary setValue:[item objectAtIndex:1] forKey:[item objectAtIndex:0]];
            }
        }
    }
    
    return dictionary;
}

#pragma mark- 刷新AccessToken


// 刷新AccessToken
- (BOOL)refreshAccessToken:(NSString **)errorMsg
{
    // DDLogInfo(@"同步方式刷新 AccessToken");
    
    NSURL* url	= [NSURL URLWithString:[self link_refresh_token_url]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:5.0]; //避免启动过慢
    
    // 忽略https证书
    /*
     if ([url.absoluteString hasPrefix:@"https://"]) {
     [request setValidatesSecureCertificate:NO];
     }
     */
    
    NSHTTPURLResponse* response = nil;
    NSError *error = nil;
    NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    BOOL returnValue = NO;
    
    if (!error) {
        NSError *error;
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic == nil) return NO;
        
        if (jsonDic && jsonDic.count == 2) {
            NSLog(@"刷新token数据 ： %@", jsonDic);
            if ([[jsonDic objectForKey:@"error"] isEqualToString:@"invalid_grant"]) {
                // DDLogInfo(@"token刷新失败，refreshToken已经过期，重新登录");
                
                // 刷新token出错，重新登录
                OauthResultInfo *resultInfo = [self login:[UserDefaults sharedInstance].loginID withPassword:[UserDefaults sharedInstance].password];
                
                if (resultInfo.success) {
                    [UserDefaults sharedInstance].accessToken 	= _oauthResultInfo.ex_oauth_access_token;
                    [UserDefaults sharedInstance].ex_token 		= _oauthResultInfo.ex_token;
                    [UserDefaults sharedInstance].refreshToken 	= _oauthResultInfo.ex_oauth_refresh_token;
                    [UserDefaults sharedInstance].loginID 		= _oauthResultInfo.identity;
                    [UserDefaults sharedInstance].eCode 		= _oauthResultInfo.eCode;
                    
                    NSLog(@"重新登录成功");
                    
                    returnValue = YES;
                }
                else{
                    NSLog(@"重新登录失败");
                    
                }
            }
        }
        else {
            NSLog(@"token刷新成功");
            // token刷新成功
            
            [UserDefaults sharedInstance].accessToken = [jsonDic objectForKey:@"access_token"];
            [UserDefaults sharedInstance].refreshToken = [jsonDic objectForKey:@"refresh_token"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationBingoLinkAccessTokenUpdate object:[jsonDic objectForKey:@"access_token"]];
            
            returnValue = YES;
        }
    }
    
    return returnValue;
}

- (NSString*)getLoginTicket
{
    if (isNilOrEmpty2([UserDefaults sharedInstance].ex_token)) {
        //DDLogInfo(@"还未登录。");
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[self login_ticket_url]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"http.protocol.element-charset"];
    
    [request setHTTPMethod:@"POST"];
    
    // 忽略https证书
    /*
     if ([url.absoluteString hasPrefix:@"https://"]) {
     [request setValidatesSecureCertificate:NO];
     }
     */
    
    @synchronized(requestArray) {
        /* 清空之前的请求
         for (NSMutableURLRequest *req in requestArray) {
         [req clearDelegatesAndCancel];
         }
         */
        
        [requestArray removeAllObjects];
        [requestArray addObject:request];
    }
    
    NSHTTPURLResponse* response = nil;
    NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString* responseString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSDictionary* resultDic = [self getResultsFromString:responseString];
    
    NSString* ex_login_ticket = resultDic[@"ex.login_ticket"];
    
    return ex_login_ticket;
    
}

BOOL isNilOrEmpty2(id obj)
{
    static Class        strClass = 0;
    static Class        arrClass = 0;
    static Class        dicClass = 0;
    static Class        nulClass = 0;
    static dispatch_once_t	onceToken;
    
    dispatch_once(&onceToken, ^{
        strClass = [NSString class];
        arrClass = [NSArray class];
        dicClass = [NSDictionary class];
        nulClass = [NSNull class];
    });
    
    if (obj) {
        if ([obj isKindOfClass:nulClass]) {
            return YES;
        }
        else if ([obj isKindOfClass:strClass]) {
            return ((NSString*)obj).length <= 0;
        }
        else if ([obj isKindOfClass:arrClass]) {
            return ((NSArray*)obj).count <= 0;
        }
        else if ([obj isKindOfClass:dicClass]) {
            return ((NSDictionary*)obj).count <= 0;
        }
        return NO;
    }
    
    return YES;
}

/**
 *  注销
 */
- (BOOL)logout{
    [[UserDefaults sharedInstance] resetUserInfo];
    
    return YES;
}

@end

