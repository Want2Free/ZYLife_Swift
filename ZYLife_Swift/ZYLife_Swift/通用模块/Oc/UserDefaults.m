//
//  UserDefaults.m
//  SSOTest
//
//  Created by 张 宏飞 on 12-8-21.
//  Copyright (c) 2012年 --. All rights reserved.
//

#import "UserDefaults.h"
#import "MyKeyChainHelper.h"

#import "SY_CommunityModel.h"

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
        _isFirstUse = [defaults boolForKey:@"isFirstUse"];
    }
    
    //MyLog(@"%@",[self DatabaseDirectory]);

	return self;
}


/**
 *  从settings里面读取配置信息，写到userDefault中
 */
+ (void)registerDefaultsFromSettingsBundle
{
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
	if (!settingsBundle) {
		MyLog(@"Could not find Settings.bundle");
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

- (NSInteger)getNewMsgCount
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"newMsgDict"];
    return [[dict objectForKey:_loginID] integerValue];
}

- (void)setBbsTypeAry:(NSArray *)bbsTypeAry
{
    _bbsTypeAry = bbsTypeAry;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bbsTypeAry];
    [UserDefaults resetUserDefaults:data forKey:@"bbsTypeAry"];
}

- (void)setPmTypeAry:(NSArray *)pmTypeAry
{
    _pmTypeAry = pmTypeAry;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pmTypeAry];
    [UserDefaults resetUserDefaults:data forKey:@"pmTypeAry"];
}

- (void)setCommunityDict:(NSMutableDictionary *)communityDict
{
    _communityDict = communityDict;
    [UserDefaults resetUserDefaults:_communityDict forKey:@"communityDict"];
}

- (NSMutableDictionary *)getCommunityDict
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"communityDict"];
}

- (NSArray *)getBbsTypeAry
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"bbsTypeAry"]];
}

- (NSArray *)getPmTypeAry
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"pmTypeAry"]];
}

- (BOOL)isHasCommunityOfCurrentUser
{
    NSDictionary *dict = [self getCommunityDict];
    return [dict[_loginID] boolValue];
}

- (NSString *)getCommunityIdOfCurrentUser
{
    return [self getCommunityDict][_loginID];
}

- (void)setCommunityId:(NSString *)communityId
{
    _communityId = communityId;
    [UserDefaults resetUserDefaults:_communityId forKey:@"communityId"];
    
    //重置communityDict
    NSMutableDictionary *dict = [self getCommunityDict] ? [[self getCommunityDict] mutableCopy] : [NSMutableDictionary dictionary];
    [dict setObject:_communityId forKey:_loginID];
    [UserDefaults resetUserDefaults:dict forKey:@"communityDict"];
}

- (NSString *)getMyCommunityId
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"communityId"];
}

- (NSString *)getMyCommunityName
{
    return [[NSUserDefaults standardUserDefaults]  stringForKey:[NSString stringWithFormat:@"%@%@",[UserDefaults sharedInstance].loginID,@"communityName"]];
}

- (void)setCommunityName:(NSString *)communityName
{
    _communityName = communityName;
    [UserDefaults resetUserDefaults:_communityName forKey:[NSString stringWithFormat:@"%@%@",[UserDefaults sharedInstance].loginID,@"communityName"]];
}

- (void)setIsFirstUse:(BOOL)isFirstUse
{
    _isFirstUse = isFirstUse;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isFirstUse forKey:@"isFirstUse"];
    [defaults synchronize];
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
        //MyLog(@"token设置了空值。");
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

- (void)setNewMsgCount:(NSInteger)newMsgCount
{
    _newMsgCount = newMsgCount;
    
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newMsgDict"] mutableCopy];
    if (!dict) dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(_newMsgCount) forKey:_loginID];
//    NSDictionary *dict = @{_loginID : @(_newMsgCount)};
    [UserDefaults resetUserDefaults:dict forKey:@"newMsgDict"];
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
//首页类型
- (void)setOperaType:(NSInteger)operaType{
    
    _operaType = operaType;
    
    [UserDefaults resetUserDefaults:@(_operaType) forKey:@"operaType"];
    
    //重置CommunityOperaTypeDict
    NSMutableDictionary *dict = [self getCommunityOperaTypeDict] ? [[self getCommunityOperaTypeDict] mutableCopy] : [NSMutableDictionary dictionary];
    [dict setObject:@(_operaType) forKey:_loginID];
    [UserDefaults resetUserDefaults:dict forKey:@"communityOperaTypeDict"];
}
- (NSInteger)getOperaType{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"operaType"];
}

- (NSMutableDictionary *)getCommunityOperaTypeDict{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"communityOperaTypeDict"];
}

- (NSInteger)isHasOperaType{
    
    NSDictionary * dict = [self getCommunityOperaTypeDict];
    return [dict[_loginID] integerValue];
}

//保存小区列表到本地
- (void)saveCommunityList:(NSMutableArray *)listArr{

    NSMutableArray * arr = [NSMutableArray new];
    
    for (SY_CommunityModel * model in listArr) {
        
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
        
        [arr addObject:data];
    }
    
    NSArray * locarr = [NSArray arrayWithArray:arr];
    
    [[NSUserDefaults standardUserDefaults] setObject:locarr forKey:COMMUNITY_DATA_LOCALKEY];
    
    [[NSUserDefaults  standardUserDefaults] synchronize];
}
//获取小区列表模型
- (NSMutableArray *)getCommunityList{

    //获取本地存储
    NSArray * locarr = [[NSUserDefaults standardUserDefaults] objectForKey:COMMUNITY_DATA_LOCALKEY];
    
    NSMutableArray * communityList = [NSMutableArray new];
    
    for (NSData * data in locarr) {
        SY_CommunityModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [communityList addObject:model];
    }
    
    return communityList;
    
}

@end

