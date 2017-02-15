//
//  MyKeyChainHelper.m
//  KeyChainDemo
//
//  Created by 尹文高 on 15-06-10.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeyChainHelper : NSObject

/**
 *  保存私密数据
 */
+ (void) saveDataString:(NSString*)dataString
                dataKey:(NSString*)dataKey;

/**
 *  删除私密数据
 */
+ (void) deleteWithDataKey:(NSString*)dataKey;

/**
 *  获取私密数据
 */
+ (NSString*) getDataStringWithKey:(NSString*)dataKey;

@end
