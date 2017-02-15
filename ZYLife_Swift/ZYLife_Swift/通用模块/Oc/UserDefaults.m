//
//  UserDefaults.m
//  SSOTest
//
//  Created by 张 宏飞 on 12-8-21.
//  Copyright (c) 2012年 --. All rights reserved.
//

#import "UserDefaults.h"
#import "MyKeyChainHelper.h"

// 用与KeyChain保存、获取数据的秘钥
NSString * const KEY_PASSWORD = @"com.bingosoft.password";



@implementation UserDefaults

- (void)dealloc
{
	//LOGDEALLOC();
}

+ (UserDefaults *)sharedInstance
{
    static UserDefaults *sharedInstance = nil;
    
	if (sharedInstance == nil) {
		sharedInstance = [[UserDefaults alloc] init];
	}

	return sharedInstance;
}

#pragma mark -

#pragma mark 读取、设置Plist配置信息

- (id)init
{
	self = [super init];

	if (nil != self) {
        
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //[UserDefaults registerDefaultsFromSettingsBundle];
        
        _loginID		= [defaults stringForKey:@"defaultUser"];
        _userId		= [defaults stringForKey:@"userId"];
        _username	= [defaults stringForKey:@"username"];
        _password         = [MyKeyChainHelper getDataStringWithKey:KEY_PASSWORD];
        _passwordSaved		= [defaults boolForKey:@"passwordSaved"];
        _deviceToken		= [defaults stringForKey:@"deviceToken"];
        _accessToken        = [defaults stringForKey:@"accesstoken"];
        _ex_token           = [defaults stringForKey:@"ex_token"];
        _refreshToken       = [defaults stringForKey:@"refreshtoken"];
        _eCode         = [defaults stringForKey:@"eCode"];
        
        //业务
        _communityId = [[defaults objectForKey:@"communityId"] longLongValue];
        _communityName = [defaults stringForKey:@"communityName"];
    }
    
	return self;
}


/**
 *  从settings里面读取配置信息，写到userDefault中
 */
+ (void)registerDefaultsFromSettingsBundle
{
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
	if (!settingsBundle) {
		NSLog(@"Could not find Settings.bundle");
		return;
	}
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary	*settings		= [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
	NSArray			*preferences	= [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
	for (NSDictionary *prefSpecification in preferences) {
		NSString *key = [prefSpecification objectForKey:@"Key"];
		if (key) {
			id value = [prefSpecification objectForKey:@"DefaultValue"];
			[defaultsToRegister setObject:value forKey:key];
		}
	}
    
    [defaults registerDefaults:defaultsToRegister];
	[defaults synchronize];
}


/**
 *  重新设置UserDefault的值
 *  *pama   value   要设置的值
 *  *pama   key     是设置的键
 */
+ (void) resetUserDefaults:(id) value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:value forKey:key];
	[defaults synchronize];
}

+ (void) resetBoolUserDefaults:(BOOL ) boolValue forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:boolValue forKey:key];
	[defaults synchronize];
}
#pragma mark

#pragma mark 属性设置并同步

- (void) setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    [UserDefaults resetUserDefaults:deviceToken forKey:@"deviceToken"];
}

- (void) setUserId:(NSString *)userId
{
    _userId =   userId;
    [UserDefaults resetUserDefaults:_userId forKey:@"userId"];
}

- (NSString *) getUserId
{
    return self.userId;
}

- (void) setUsername:(NSString *)username
{
    _username = username;
    [UserDefaults resetUserDefaults:username forKey:@"username"];
}

- (void) setPassword:(NSString *)password
{
    _password = password;
    // 使用安全秘钥保存密码
    [MyKeyChainHelper saveDataString:password dataKey:KEY_PASSWORD];
    //[UserDefaults resetUserDefaults:password forKey:@"password"];
}

- (void) setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    [UserDefaults resetUserDefaults:accessToken forKey:@"accesstoken"];
}

- (NSString *)getAccessToken
{
    return _accessToken;
    /*
    NSString *token =  checkNullStr2(_accessToken);
    if (token.length < 1) {
        //如果token为空，设置一个无效的token
        token = @"00000000-0000-0000-0000-000000000000";
    }
    
    return token;
     */
}

id checkNullStr2(id obj)
{
    static Class			strClass = 0;
    static dispatch_once_t	onceToken;
    
    dispatch_once(&onceToken, ^{
        strClass = [NSString class];
    });
    
    if (!obj || !([obj isKindOfClass:strClass])) {
        return @"";
    } else {
        return obj;
    }
}

- (void)setEx_token:(NSString *)ex_token
{
    if (ex_token == nil) {
        //NSLog(@"token设置了空值。");
    }
    _ex_token = [ex_token copy];
    [UserDefaults resetUserDefaults:ex_token forKey:@"ex_token"];
}

-(NSString*)ex_token
{
    return [_ex_token copy];
}

- (void) setRefreshToken:(NSString *)refreshToken
{
    _refreshToken = refreshToken;
    [UserDefaults resetUserDefaults:refreshToken forKey:@"refreshtoken"];
}

- (void) setLoginID:(NSString *)loginID
{
    _loginID = loginID;
    [UserDefaults resetUserDefaults:loginID forKey:@"defaultUser"];
}

- (void) setPasswordSaved:(BOOL)passwordSaved
{
    _passwordSaved = passwordSaved;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:passwordSaved forKey:@"passwordSaved"];
	[defaults synchronize];
}

- (void) setECode:(NSString *)eCode
{
    _eCode = eCode;
    [UserDefaults resetUserDefaults:eCode forKey:@"eCode"];
}

- (NSString *) getECode
{
    return _eCode;
}

//业务
- (void)setCommunityId:(long long)communityId
{
    _communityId = communityId;
    
    [UserDefaults resetUserDefaults:@(communityId) forKey:@"communityId"];
}

- (void)setCommunityName:(NSString *)communityName
{
    _communityName = communityName;
    [UserDefaults resetUserDefaults:communityName forKey:@"communityName"];
}

/**
 *  功能：重置用户登录信息
 */
- (void) resetUserInfo
{
    if (self.userId) {
        
        self.logoutUserId = self.userId;
    }
    self.userId = nil;
    self.username = nil;
    self.accessToken = nil;
    self.ex_token = nil;
    self.loginID = nil;
    
    [self deletePassword];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:@"logout"];
    [defaults setBool:NO forKey:@"forceLogin"];
	[defaults synchronize];
}

- (void) deletePassword
{
    [MyKeyChainHelper deleteWithDataKey:KEY_PASSWORD];
}

- (void) accessTokenExpires
{
    //暂无处理
}

@end

