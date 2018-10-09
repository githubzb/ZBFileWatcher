//
//  ZBFileWatcher.m
//  fileWatcher
//
//  Created by 张宝 on 2018/10/9.
//  Copyright © 2018 dr.box. All rights reserved.
//

#import "ZBFileWatcher.h"

@interface ZBFileWatcher ()

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) ZBFileWatcherHandler handler;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, assign) BOOL needRestart;

@end
@implementation ZBFileWatcher

- (instancetype)initWithFilePath:(NSString *)filePath
                         handler:(ZBFileWatcherHandler)handler{
    self = [super init];
    if (self) {
        _filePath = [filePath copy];
        _handler = [handler copy];
    }
    return self;
}

+ (instancetype)watchFilePath:(NSString *)filePath
                      handler:(ZBFileWatcherHandler)handler{
    return [[ZBFileWatcher alloc] initWithFilePath:filePath handler:handler];
}

- (void)start{
    if (self.source) {
        return;
    }
    NSParameterAssert(self.filePath.length>0);
    int f = open([self.filePath fileSystemRepresentation], O_RDONLY);
    if (f<0) {
        [self printLog:@"⚠️file open fail：%i", f];
        return;
    }
    unsigned long const mask = DISPATCH_VNODE_DELETE |
    DISPATCH_VNODE_WRITE |
    DISPATCH_VNODE_EXTEND |
    DISPATCH_VNODE_ATTRIB |
    DISPATCH_VNODE_LINK |
    DISPATCH_VNODE_RENAME |
    DISPATCH_VNODE_REVOKE |
    DISPATCH_VNODE_FUNLOCK;
    dispatch_queue_t queue = dispatch_queue_create("fileWatcher",
                                                   DISPATCH_QUEUE_SERIAL);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                         f,
                                         mask,
                                         queue);
    dispatch_source_set_event_handler(self.source, ^{
        unsigned long const type = dispatch_source_get_data(self.source);
        if (type&DISPATCH_VNODE_DELETE) {
            self.needRestart = YES;
            [self stop];
        }
        [self callHandlerInMainThread];
    });
    dispatch_source_set_cancel_handler(self.source, ^{
        int f = (int)dispatch_source_get_handle(self.source);
        close(f);
        self.source = nil;
        self.watching = NO;
        if (self.needRestart) {
            self.needRestart = NO;
            [self start];
        }
    });
    dispatch_resume(self.source);
    _watching = YES;
}
- (void)stop{
    if (self.source) {
        dispatch_source_cancel(self.source);
    }
}

#pragma mark - private
- (void)printLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
#if DEBUG
    va_list ap;
    va_start(ap, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    NSLog(@"👁log:%@", str);
#endif
}
- (void)callHandlerInMainThread{
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(self.filePath);
        });
    }
}

@end
