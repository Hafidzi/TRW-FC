//
//  TRWNewsViewController.m
//  TRW FC
//
//  Created by Mohd Hafidzi Mat Yasin on 3/21/13.
//  Copyright (c) 2013 Mohd Hafidzi Mat Yasin. All rights reserved.
//

#import "TRWNewsViewController.h"

@interface TRWNewsViewController ()

@end

@implementation TRWNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:210/255.0f green:1/255.0f blue:3/255.0f alpha:1];

    NSString *newsURL = @"http://kelate.net";
    NSURL *url = [NSURL URLWithString:newsURL];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.newsView loadRequest:reqObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
