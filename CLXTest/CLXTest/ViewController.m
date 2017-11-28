//
//  ViewController.m
//  CLXTest
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "ViewController.h"
#import "CLXTableViewController.h"
@import CLXBaseUtility;

@interface ViewController ()

@end

@implementation ViewController
{
    __weak NSString *w_str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CLXKeychain *keychian = [CLXKeychain new];
    CLXKeychainItem *item = [CLXKeychainItem new];

    item.secAccount = @"liangxiu.chen";
    item.secServiceName = @"login";
    item.secData = [NSData dataWithData:[@"nihao" dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;

    [keychian addKeychainItem:item error:&error];
    error = nil;
    item.secAccount = @"chen.liangxiu";
    CLXKeychainQuery *query = [CLXKeychainQuery new];
    query.accountForQuery = @"liangxiu.chen";
    query.serviceNameForQuery = @"login";
    [keychian updateKeyChainItem:item InQuery:query error:&error];
    query.accountForQuery = @"chen.liangxiu";
    __unused CLXKeychainItem *item1 = [keychian keychainItemForQuery:query error:&error];

    //timer
    CLXTimer *timer = [CLXTimer timer];
    timer.shouldReapt = YES;
    timer.interval = 1;
    [timer fireWithAction:^(CLXTimer *timer) {
        NSLog(@"%p",timer);
    } OnCancel:^(CLXTimer *timer) {
        NSLog(@"%p",timer);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CLXTableViewController *tableViewController = [CLXTableViewController new];
    [self presentViewController:tableViewController animated:NO completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
