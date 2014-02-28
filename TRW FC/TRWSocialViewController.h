//
//  TRWSocialViewController.h
//  TRW FC
//
//  Created by Mohd Hafidzi Mat Yasin on 3/26/13.
//  Copyright (c) 2013 Mohd Hafidzi Mat Yasin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TRWSocialViewController : UIViewController
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIImageView *bannerImageView;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *usernameLabel;
    
    IBOutlet UILabel *tweetsLabel;
    IBOutlet UILabel *followingLabel;
    IBOutlet UILabel *followersLabel;
    
    IBOutlet UITextView *tweetTextView;
    
    NSString *username;
}

@property (nonatomic,retain)NSString *username;

@end
