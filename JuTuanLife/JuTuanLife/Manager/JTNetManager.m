//
//  JTNetManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTNetManager.h"
#import "CKOpenUDID.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation JTNetManager

+ (void)setupNetManager
{
    JTNetManager *manager = [self sharedInstance];
//    manager.defaultTimeOut = 10;
    [WCNetManager setup:manager];
}

#pragma mark - WCNetManagerProtocol

- (NSString *)userToken
{
    return [JTUserManager sharedInstance].ac_token;
}

- (void)setUserTokenParams:(NSMutableDictionary *)params
{
    [params safeSetObject:[self userToken] forKey:@"_ac_token"];
}

- (NSDictionary *)systemParams
{
    static NSMutableDictionary *params = nil;
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
        [params safeSetObject:@"app" forKey:@"_platform"];
        [params safeSetObject:@"ios" forKey:@"_os"];
        [params safeSetObject:@"JuTuiBang" forKey:@"_caller"];
        [params safeSetObject:[self.class bundleShortVersion] forKey:@"_appVersion"];
        [params safeSetObject:[UIDevice currentDevice].systemVersion forKey:@"_sysVersion"];
        [params safeSetObject:[self.class machineModel] forKey:@"_model"];
        [params safeSetObject:[self.class openUDID] forKey:@"_openUDID"];
        [params safeSetObject:@"AppStore" forKey:@"_appChannel"];
//        [params safeSetObject:[self.class clientUDID] forKey:@"cUDID"];
        if (APP_DEBUG) {
            [params safeSetObject:@"true" forKey:@"__intern__show-error-mesg"];
        }
        // jailbroken
        //        if ([self.class isJailbroken]) {
        //            [params safeSetObject:@"1" forKey:@"jb"];
        //        }
    }
    return params;
}

+ (NSString *)bundleShortVersion
{
    static NSString *bundleShortVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    });
    return bundleShortVersion;
}

+ (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (NSString *)openUDID
{
    static NSString *openUDID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        openUDID = [CKOpenUDID value];
    });
    return openUDID;
}

+ (NSString *)macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *)clientUDID
{
    static NSString *clientUDID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
        if ([[array firstObject] floatValue]>=7) {
            clientUDID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            clientUDID = [self macAddress];
        }
    });
    return clientUDID;
}

- (BOOL)isJailbroken {
#if TARGET_OS_SIMULATOR
    // Dont't check simulator
    return NO;
#endif
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString createUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

+ (BOOL)isJailbroken
{
    static BOOL isJB = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isJB = [self isJailbroken];
    });
    return isJB;
}

@end
