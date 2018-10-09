//
//  ZBFileWatcher.h
//  fileWatcher
//
//  Created by 张宝 on 2018/10/9.
//  Copyright © 2018 dr.box. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZBFileWatcherHandler)(NSString *filePath);

NS_ASSUME_NONNULL_BEGIN

@interface ZBFileWatcher : NSObject

@property (nonatomic, assign) BOOL watching;

- (instancetype)initWithFilePath:(NSString *)filePath
                         handler:(ZBFileWatcherHandler)handler;
+ (instancetype)watchFilePath:(NSString *)filePath
                      handler:(ZBFileWatcherHandler)handler;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
