//
//  ChatAppUserDefaults.m
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 20/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import "ChatAppUserDefaults.h"

@implementation ChatAppUserDefaults
+(void)setValue:(NSString *)value forKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setObject:(id)object forKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+(void)removeObjectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+(id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(BOOL)Synchronize
{
    return [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
+(void)ResetChatDefaults
{
    return [NSUserDefaults resetStandardUserDefaults];
}
+(void)ClearChatDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    return [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
