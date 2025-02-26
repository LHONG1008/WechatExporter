//
//  AppConfiguration.m
//  WechatExporter
//
//  Created by Matthew on 2021/3/18.
//  Copyright © 2021 Matthew. All rights reserved.
//

#import "AppConfiguration.h"
#include "Utils.h"
#include "PdfConverterImpl.h"
#include "ExportOption.h"

#define ASYNC_NONE              0
#define ASYNC_ONSCROLL          1
#define ASYNC_PAGER_NORMAL      2
#define ASYNC_PAGER_ON_YEAR     3
#define ASYNC_PAGER_ON_MONTH    4

@implementation AppConfiguration

+ (NSInteger)getAsyncLoadingValue
{
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"AsyncLoading"];
    if (nil == obj)
    {
        return ASYNC_ONSCROLL;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"AsyncLoading"];
}

+ (void)setDescOrder:(BOOL)descOrder
{
    [[NSUserDefaults standardUserDefaults] setBool:descOrder forKey:@"DescOrder"];
}

+ (BOOL)getDescOrder
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DescOrder"];
}

+ (BOOL)IsPdfSupported
{
    PdfConverterImpl converter(NULL);
    return converter.isPdfSupported() ? YES : NO;
}

+ (NSInteger)getOutputFormat
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"OutputFormat"];
}

+ (BOOL)isHtmlMode
{
    return [self getOutputFormat] == OUTPUT_FORMAT_HTML;
}

+ (BOOL)isTextMode
{
    return [self getOutputFormat] == OUTPUT_FORMAT_TEXT;
}

+ (BOOL)isPdfMode
{
    return [self getOutputFormat] == OUTPUT_FORMAT_PDF;
}

+ (void)setOutputFormat:(NSInteger)outputFormat
{
    [[NSUserDefaults standardUserDefaults] setInteger:outputFormat forKey:@"OutputFormat"];
}

+ (void)setSavingInSession:(BOOL)savingInSession
{
    [[NSUserDefaults standardUserDefaults] setBool:(!savingInSession) forKey:@"UniversalFolder"];
}

+ (BOOL)getSavingInSession
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"UniversalFolder"];
}

+ (void)setSyncLoading
{
    [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_NONE forKey:@"AsyncLoading"];
}

+ (BOOL)getSyncLoading
{
    return [AppConfiguration getAsyncLoadingValue] == ASYNC_NONE;
}

+ (void)setIncrementalExporting:(BOOL)incrementalExp
{
    [[NSUserDefaults standardUserDefaults] setBool:incrementalExp forKey:@"IncrementalExp"];
}

+ (BOOL)getIncrementalExporting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"IncrementalExp"];
}
   
+ (void)setLastOutputDir:(NSString *)outputDir
{
    [[NSUserDefaults standardUserDefaults] setObject:outputDir forKey:@"OutputDir"];
}

+ (NSString *)getLastOrDefaultOutputDir
{
    NSString *outputDir = [[NSUserDefaults standardUserDefaults] stringForKey:@"OutputDir"];
    if (nil != outputDir && outputDir.length > 0)
    {
        return outputDir;
    }

    return [self getDefaultOutputDir];
}

+ (NSString *)getDefaultOutputDir
{
    NSMutableArray *components = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (nil == paths && paths.count > 0)
    {
        [components addObject:[paths objectAtIndex:0]];
    }
    else
    {
        [components addObject:NSHomeDirectory()];
        [components addObject:@"Documents"];
    }
    [components addObject:@"WechatHistory"];
    
    return [NSString pathWithComponents:components];
}

+ (void)setLastBackupDir:(NSString *)backupDir
{
    [[NSUserDefaults standardUserDefaults] setObject:backupDir forKey:@"BackupDir"];
}

+ (NSString *)getLastBackupDir
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"BackupDir"];
}

+ (NSString *)getDefaultBackupDir:(BOOL)checkExistence // YES
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupport = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSArray *components = @[[appSupport path], @"MobileSync", @"Backup"];
    NSString *backupDir = [NSString pathWithComponents:components];
    if (!checkExistence)
    {
        return backupDir;
    }
    
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:backupDir isDirectory:&isDir] && isDir)
    {
        return backupDir;
    }
    
    return nil;
}

+ (NSInteger)getLastCheckUpdateTime
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"LastChkUpdateTime"];
}

+ (void)setLastCheckUpdateTime
{
    [self setLastCheckUpdateTime:0];
}

+ (void)setLastCheckUpdateTime:(NSInteger)lastCheckUpdateTime
{
    if (0 == lastCheckUpdateTime)
    {
        lastCheckUpdateTime = static_cast<NSInteger>(getUnixTimeStamp());
    }
    [[NSUserDefaults standardUserDefaults] setInteger:lastCheckUpdateTime forKey:@"LastChkUpdateTime"];
}

+ (void)setCheckingUpdateDisabled:(BOOL)disabled
{
    [[NSUserDefaults standardUserDefaults] setBool:disabled forKey:@"ChkUpdateDisabled"];
}

+ (BOOL)isCheckingUpdateDisabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChkUpdateDisabled"];
}

+ (void)setLoadingDataOnScroll
{
    [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_ONSCROLL forKey:@"AsyncLoading"];
}

+ (BOOL)getLoadingDataOnScroll
{
    return [AppConfiguration getAsyncLoadingValue] == ASYNC_ONSCROLL;
}

+ (void)setNormalPagination
{
    [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_PAGER_NORMAL forKey:@"AsyncLoading"];
}

+ (BOOL)getNormalPagination
{
    return [AppConfiguration getAsyncLoadingValue] == ASYNC_PAGER_NORMAL;
}

+ (void)setPaginationOnYear
{
    [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_PAGER_ON_YEAR forKey:@"AsyncLoading"];
}

+ (BOOL)getPaginationOnYear
{
    return [AppConfiguration getAsyncLoadingValue] == ASYNC_PAGER_ON_YEAR;
}

+ (void)setPaginationOnMonth
{
    [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_PAGER_ON_MONTH forKey:@"AsyncLoading"];
}

+ (BOOL)getPaginationOnMonth
{
    return [AppConfiguration getAsyncLoadingValue] == ASYNC_PAGER_ON_MONTH;
}

+ (void)setSupportingFilter:(BOOL)supportingFilter
{
    [[NSUserDefaults standardUserDefaults] setBool:(!supportingFilter) forKey:@"NoFilter"];
}

+ (BOOL)getSupportingFilter
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"NoFilter"];
}

+ (void)setOutputDebugLogs:(BOOL)dbgLogs
{
    [[NSUserDefaults standardUserDefaults] setBool:dbgLogs forKey:@"OutputDebugLogs"];
}

+ (BOOL)outputDebugLogs
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"OutputDebugLogs"];
}

+ (void)setIncludingSubscriptions:(BOOL)includingSubscriptions
{
    [[NSUserDefaults standardUserDefaults] setBool:includingSubscriptions forKey:@"IncludingSubscriptions"];
}

+ (BOOL)includeSubscriptions
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"IncludingSubscriptions"];
}

+ (void)setOpenningFolderAfterExp:(BOOL)openningFolderAfterExp
{
    [[NSUserDefaults standardUserDefaults] setBool:openningFolderAfterExp forKey:@"OpenningFolderAfterExp"];
}

+ (BOOL)getOpenningFolderAfterExp
{
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenningFolderAfterExp"];
    return (nil == obj) ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:@"OpenningFolderAfterExp"];
}

+ (void)setSkipGuide:(BOOL)skipGuide
{
    [[NSUserDefaults standardUserDefaults] setBool:skipGuide forKey:@"SkipGuide"];
}

+ (BOOL)getSkipGuide
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SkipGuide"];
}

+ (void)upgrade
{
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"SyncLoading"];
    if (obj != nil)
    {
        BOOL val = [[NSUserDefaults standardUserDefaults] boolForKey:@"SyncLoading"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SyncLoading"];
        if (val)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_NONE forKey:@"AsyncLoading"];
        }
    }
    
    obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoadingOnScroll"];
    if (obj != nil)
    {
        BOOL val = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoadingOnScroll"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoadingOnScroll"];
        if (val)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:ASYNC_ONSCROLL forKey:@"AsyncLoading"];
        }
    }
    
}

+ (uint64_t)buildOptions
{
    ExportOption options;

    if ([AppConfiguration isTextMode])
    {
        options.setTextMode();
    }
    if ([AppConfiguration isPdfMode])
    {
        options.setPdfMode();
    }
    
    options.setOrder(![AppConfiguration getDescOrder]);

    // getSavingInSession
    
    if ([AppConfiguration getSyncLoading])
    {
        options.setSyncLoading();
    }
    else
    {
        // options.setSyncLoading(false);
        if ([AppConfiguration getLoadingDataOnScroll])
        {
            options.setLoadingDataOnScroll([AppConfiguration getLoadingDataOnScroll]);
        }
        if ([AppConfiguration getNormalPagination])
        {
            options.setPager();
        }
        if ([AppConfiguration getPaginationOnYear])
        {
            options.setPagerByYear();
        }
        if ([AppConfiguration getPaginationOnMonth])
        {
            options.setPagerByMonth();
        }
        // options.set([AppConfiguration getLoadingDataOnScroll]);
    }
    
    options.setIncrementalExporting([AppConfiguration getIncrementalExporting]);
    options.supportsFilter([AppConfiguration getSupportingFilter]);
    
    options.outputDebugLogs([AppConfiguration outputDebugLogs]);
    if ([AppConfiguration includeSubscriptions])
    {
        options.includesSubscription();
    }

    return (uint64_t)options;
}


@end
