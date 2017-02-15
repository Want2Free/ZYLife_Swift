//
//  UserDefaults.h
//  SSOTest
//
//  Created by 张 宏飞 on 12-8-21.
//  重构:梁乐 2013-12-3
//  Copyright (c) 2012年 --. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  组织类型
 */
typedef enum {
	OrgType_In	= 1,		// 内部组织
	OrgType_Out = 2			// 外部组织
} OrgType;

@interface UserDefaults : NSObject
{
    NSString *_accessToken;
    NSString *_ex_token;
    NSString *_eCode;
}

#pragma mark 属性

// 当前设备标志
@property (nonatomic, copy) NSString *deviceToken;

/* ==================================== 用户信息 ==================================== */

@property (nonatomic, copy) NSString *loginID;
// 当前用户ID
@property (nonatomic, copy) NSString *userId;
// 注销的用户ID
@property (nonatomic, copy) NSString *logoutUserId;
// 当前用户姓名
@property (nonatomic, copy) NSString *username;
// 密码
@property (nonatomic, copy) NSString *password;

// 组织类型
@property (nonatomic, assign) OrgType orgType;

/* ==================================== 认证信息 ==================================== */

@property (nonatomic, copy, getter=getAccessToken,setter = setAccessToken:) NSString *accessToken;
@property (nonatomic, copy) NSString *ex_token;
// 刷新token
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *eCode;


/* ==================================== 用户配置项 ==================================== */

// 是否保存密码
@property (nonatomic, assign) BOOL passwordSaved;

//业务

/**
 已选小区名称
 */
@property (nonatomic,copy) NSString *communityName;

/**
 已选小区ID
 */
@property (nonatomic,assign) long long communityId;

/* ==================================== 方法 ==================================== */

#pragma mark 方法

/*单例*/
+ (UserDefaults *)sharedInstance;

/**
 *  重新设置UserDefault的值
 *  *pama   value   要设置的值
 *  *pama   key     是设置的键
 */
+ (void)resetUserDefaults:(id)value forKey:(NSString *)key;

/**
 *  从settings里面读取配置信息，写到userDefault中
 */
+ (void)registerDefaultsFromSettingsBundle;

/**
 *  功能：重置用户登录信息
 */
- (void)resetUserInfo;

/**
 *  删除用户密码
 */
- (void)deletePassword;

/**
	token过期
 */
- (void)accessTokenExpires;

@end

