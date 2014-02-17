//
//  ViewController.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "ViewController.h"
#import "MentionViewController.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *viewControllers;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.viewControllers = [[NSMutableArray alloc] init];
    double delayInSeconds = 2;
    for (int i = 1; i < 4; i++) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            MentionViewController *controller = [[MentionViewController alloc] init];
            self.navigationController.delegate = controller;
            [self.navigationController pushViewController:controller animated:YES];
            
            [self.viewControllers addObject:controller];
        });
    }
}

@end
