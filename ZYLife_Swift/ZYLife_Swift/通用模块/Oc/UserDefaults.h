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
//小区id
@property (nonatomic,copy) NSString *communityId;
//小区名称
@property (nonatomic,copy) NSString *communityName;
//小区用户-默认字典{loginID:comnunityName}
@property (nonatomic,strong) NSMutableDictionary *communityDict;

//缓存论坛类别、拍卖类别（针对不同小区）
//{communityId : types}
@property (nonatomic,strong) NSArray *bbsTypeAry;
@property (nonatomic,strong) NSArray *pmTypeAry;

//是否首次使用
@property (nonatomic) BOOL isFirstUse;

//新消息条数
@property (nonatomic) NSInteger newMsgCount;

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

- (NSString *)getMyCommunityId;

- (NSString *)getMyCommunityName;

- (NSDictionary *)getCommunityDict;

- (NSArray *)getPmTypeAry;

- (NSArray *)getBbsTypeAry;

- (NSInteger)getNewMsgCount;

/**
 *  当前用户是否有默认小区
 *
 *  @return 是否有选小区
 */
- (BOOL)isHasCommunityOfCurrentUser;

/**
 *  获取当前用户的小区id
 *
 *  @return 小区id
 */
- (NSString *)getCommunityIdOfCurrentUser;

//首页类型<1.开门首页 2.红包首页>
@property (nonatomic,assign) NSInteger operaType;

- (NSInteger)getOperaType;

- (NSInteger)isHasOperaType;

- (void)saveCommunityList:(NSMutableArray*)listArr;
- (NSMutableArray *)getCommunityList;

@end

