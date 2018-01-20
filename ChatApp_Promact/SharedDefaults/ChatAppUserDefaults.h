//
//  ChatAppUserDefaults.h
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 20/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatAppUserDefaults : NSObject
+(void)setValue:(NSString *)value forKey:(NSString *)key;

+(void)setObject:(id)object forKey:(NSString *)key;

+(NSString *)valueForKey:(NSString *)key;

+(id)objectForKey:(NSString *)key;

+(BOOL)Synchronize;

+(void)removeObjectForKey:(NSString *)key;

+(void)ResetChatDefaults;

+(void)ClearChatDefaults;
@end
