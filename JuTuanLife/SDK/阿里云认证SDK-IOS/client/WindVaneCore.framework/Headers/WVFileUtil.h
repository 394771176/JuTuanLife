/*
 * WVFileUtil.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface WVFileUtil : NSObject

/**
 * 获取 WindVane Config 目录 Documents/wvapp/config。
 */
+ (NSString *)getConfigPath;

/**
 * 获取 WindVane 缓存目录 /Library/Caches/WindVane。
 */
+ (NSString *)getCachesPath;

/**
 * 获取与指定 URL 相关的 WindVane 缓存目录文件 /Library/Caches/WindVane/md5(url).ext。
 * 会移除 URL 的 query 和 fragment，只保留路径本身。
 */
+ (NSString *)getCachesFilePath:(NSString *)url;

#pragma mark - pathUtil

/**
 * 创建指定路径的文件夹。
 *
 * @param path  要创建的文件夹路径。
 *
 * @return 是否成功创建文件夹。
 */
+ (BOOL)createFolder:(NSString *)path;

/**
 * 创建指定路径的文件夹。
 *
 * @param path  要创建的文件夹路径。
 * @param error 创建文件夹的错误信息。
 *
 * @return 是否成功创建文件夹。
 */
+ (BOOL)createFolder:(NSString *)path error:(NSError **)error;

/**
 * 创建指定文件夹，并拒绝被 iCloud 同步。
 *
 * @param path  要创建的文件夹路径。
 */
+ (void)createFolderWithoutBackup:(NSString *)path;

/**
 * 移除指定路径的文件/文件夹。
 *
 * @param path  要移除的文件/文件夹路径。
 *
 * @return 是否成功移除文件夹。
 */
+ (BOOL)removeItemAtPath:(NSString *)path;

/**
 * 移除指定路径的文件/文件夹。
 *
 * @param path  要移除的文件/文件夹路径。
 * @param error 移除文件夹的错误信息。
 *
 * @return 是否成功移除文件夹。
 */
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

/**
 * 设置文件的属性，拒绝被 iCloud 同步。
 */
+ (BOOL)addSkipBackupAttributesToFile:(NSURL *)filePath;

@end
