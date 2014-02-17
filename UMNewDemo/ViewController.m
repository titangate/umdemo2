//
//  ViewController.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "ViewController.h"
#import "MentionViewController.h"

@interface ViewController () <MentionViewControllerDelegate>
@property (nonatomic) NSMutableArray *viewControllers;
@end

@implementation ViewController

- (MentionViewController *)createNewMentionViewControllerAtIndex:(NSInteger)index {
    MentionViewController *controller = [[MentionViewController alloc] init];
    [controller setImage:[UIImage imageNamed:@"earthporn"]];
    [controller setText:[NSString stringWithFormat:@"This is the %dth mention", index]];
    return controller;
}

- (void)viewDidLoad {
    self.viewControllers = [[NSMutableArray alloc] init];
    MentionViewController *controller = [self createNewMentionViewControllerAtIndex:0];
    self.navigationController.delegate = controller;
    [self.navigationController pushViewController:controller animated:YES];
    [self.viewControllers addObject:controller];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"earthporn"]];
    [self.view addSubview:view];
}

@end
