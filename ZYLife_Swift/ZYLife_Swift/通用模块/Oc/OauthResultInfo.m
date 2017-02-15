//
//  OauthResultInfo.m
//  BingoSled
//
//  Created by liang le on 14-1-24.
//  Copyright (c) 2014年 bingosoft. All rights reserved.
//

#import "OauthResultInfo.h"

/**
 *  sso认证结果信息
 */
@implementation OauthResultInfo

/**
 *  通过字典初始化返回结果
 */
- (OauthResultInfo *) initWithDictionary:(NSDictionary *)result
{
    OauthResultInfo *resultInfo = [[OauthResultInfo alloc] init];
    
    if (result.count > 0) {
		resultInfo.success = [[result objectForKey:@"mode"] isEqualToString:@"ok"];
	}
    
	if (resultInfo.success) {
        
		resultInfo.identity = [result objectForKey:@"identity"];
		resultInfo.ex_oauth_access_token = [result objectForKey:@"ex.oauth_access_token"];
        resultInfo.ex_oauth_access_token_expires = [[result objectForKey:@"ex.oauth_access_token_expires"] intValue];
        resultInfo.ex_oauth_refresh_token		= [result objectForKey:@"ex.oauth_refresh_token"];
        resultInfo.ex_token = [result objectForKey:@"ex.token"];
        resultInfo.ex_token_expires = [[result objectForKey:@"ex.token_expires"] intValue];
        resultInfo.eCode		= [result objectForKey:@"ex.E_CODE"];
    }
    else
    {
        resultInfo.errorMessage = [result objectForKey:@"error"];
    }
    
    return resultInfo;
}

@end
