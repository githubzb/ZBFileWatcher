//
//  ViewController.m
//  fileWatcher
//
//  Created by 张宝 on 2018/10/9.
//  Copyright © 2018 dr.box. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)clickBtn:(id)sender{
    SecondViewController *vc = [[SecondViewController alloc] initWithNibName:@"SecondViewController"
                                                                      bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
