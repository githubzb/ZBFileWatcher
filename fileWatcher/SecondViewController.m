//
//  SecondViewController.m
//  fileWatcher
//
//  Created by 张宝 on 2018/10/9.
//  Copyright © 2018 dr.box. All rights reserved.
//

#import "SecondViewController.h"
#import "ZBFileWatcher.h"

@interface SecondViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textfield;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) ZBFileWatcher *watcher;

@end

@implementation SecondViewController

- (void)dealloc{
    //这里需要终止监听，释放资源
    [self.watcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.watcher = [ZBFileWatcher watchFilePath:self.filePath
                                        handler:^(NSString *filePath)
                    {
                        __strong typeof(weakSelf) sf = weakSelf;
                        [sf showText];
                    }];
    [self.watcher start];
    if (self.watcher.watching) {
        self.stateLabel.text = @"观察中...";
    }else{
        self.stateLabel.text = @"观察器启动失败";
    }
}

- (NSString *)filePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"data.json"];
    return path;
}

- (IBAction)clickStartBtn:(id)sender{
    [self.watcher start];
    if (self.watcher.watching) {
        self.stateLabel.text = @"观察中...";
    }
}
- (IBAction)clickSureBtn:(id)sender{
    if (!self.watcher.watching) {
        self.stateLabel.text = @"观察器中断";
    }
    NSString *text = self.textfield.text;
    NSError *error;
    if (text.length==0) {
        //删除文件
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath
                                                   error:&error];
        if (error) {
            NSLog(@"❌删除文件失败：%@", error);
        }
        return;
    }
    [text writeToFile:self.filePath
           atomically:YES
             encoding:NSUTF8StringEncoding
                error:&error];
    if (error) {
        NSLog(@"❌写入文件失败：%@", error);
    }
}
- (IBAction)clickCloseBtn:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showText{
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:self.filePath
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
    if (error) {
        NSLog(@"❌读取文件失败:%@", error);
        return;
    }
    self.contentLabel.text = str;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
