//
//  TRWInitViewController.m
//  TRW FC
//
//  Created by Mohd Hafidzi Mat Yasin on 4/24/13.
//  Copyright (c) 2013 Mohd Hafidzi Mat Yasin. All rights reserved.
//

#import "TRWInitViewController.h"

@interface TRWInitViewController ()

@end

@implementation TRWInitViewController

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
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
