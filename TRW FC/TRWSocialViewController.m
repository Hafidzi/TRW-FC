//
//  TRWSocialViewController.m
//  TRW FC
//
//  Created by Mohd Hafidzi Mat Yasin on 3/26/13.
//  Copyright (c) 2013 Mohd Hafidzi Mat Yasin. All rights reserved.
//

#import "TRWSocialViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TRWSocialViewController ()

@end

@implementation TRWSocialViewController

@synthesize username;

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
    
    /*
    [profileImageView.layer setBorderWidth:4.0f];
    [profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [profileImageView.layer setShadowRadius:3.0];
    [profileImageView.layer setShadowOpacity:0.5];
    [profileImageView.layer setShadowOffset:CGSizeMake(1.0, 0.0)];
    [profileImageView.layer setShadowColor:[[UIColor blackColor] CGColor]];
     */
    
    profileImageView.layer.cornerRadius = 1.0f;
    profileImageView.clipsToBounds = YES;
    [self getInfo];
    //[self fetchTimelineForUser:@"TRWFC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getInfo{
    
    //Request access to the twitter accounts
    ACAccountStore *acctStore = [[ACAccountStore alloc] init];
    ACAccountType *acctType = [acctStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [acctStore requestAccessToAccountsWithType:acctType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accts = [acctStore accountsWithAccountType:acctType];
            
            //check if the users has setup at least one Twitter account
            
            if (accts.count > 0)
            {
                ACAccount *twitterAcct = [accts objectAtIndex:0];
                
                //create a request to get the info about a user on twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:@"TRWFC" forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAcct];
                
                /*
                NSDictionary *params = @{@"screen_name" : username,
                                         @"include_rts" : @"0",
                                         @"trim_user" : @"1",
                                         @"count" : @"1"};
                
                SLRequest *twitterRequest2 = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"http api.twitter.com/1.1/statuses/user_timeline.json"] parameters:params];
                [twitterRequest2 setAccount:twitterAcct];
                 */
                
                //making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //check if reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return ;
                        }
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        //check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWdata = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            //test
                            if (TWdata) {
                                NSLog(@"test TWdata: %@\n", TWdata);
                            }
                            
                            //filter the preferred data
                            NSString *screen_name = [(NSDictionary *) TWdata objectForKey:@"screen_name"];
                            NSString *name = [(NSDictionary *)TWdata objectForKey:@"description"]; //name
                            
                            int followers = [[(NSDictionary *) TWdata objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWdata objectForKey:@"friends_count"] integerValue];
                            int tweets = [[(NSDictionary *)TWdata objectForKey:@"statuses_count"] integerValue];
                            
                            NSString *profileImageStringURL = [(NSDictionary *)TWdata objectForKey:@"profile_image_url_https"];
                            NSString *bannerImageStringURL = [(NSDictionary *) TWdata objectForKey:@"profile_banner_url"];
                            
                            //update the interface with the loaded data
                            
                            nameLabel.text = name;
                            usernameLabel.text = [NSString stringWithFormat:@"@%@", screen_name];
                            tweetsLabel.text = [NSString stringWithFormat:@"%i", tweets];
                            followingLabel.text = [NSString stringWithFormat:@"%i", following];
                            followersLabel.text = [NSString stringWithFormat:@"%i", followers];
                            
                            NSString *lastTweet = [[(NSDictionary *)TWdata objectForKey:@"status"] objectForKey:@"text"];
                            tweetTextView.text = lastTweet;
                            
                            //get the profile image in the original resolution
                            profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                            [self getProfileImageForURLString:profileImageStringURL];
                            
                            //get the banner image, if the user has one
                            if (bannerImageStringURL) {
                                NSString *bannerURLString = [NSString stringWithFormat:@"%@/mobile_retina", bannerImageStringURL];
                                [self getBannerImageForURLString:bannerURLString];
                            }else {
                                bannerImageView.backgroundColor = [UIColor underPageBackgroundColor];
                            }
                            
                            
                        }
                    });
                }];
            }
        }else {
            NSLog(@"No access granted");
        }
    }];
}
	
- (void) getProfileImageForURLString:(NSString *)urlString;
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    profileImageView.image = [UIImage imageWithData:data];
}

- (void) getBannerImageForURLString:(NSString *)urlString;
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    bannerImageView.image = [UIImage imageWithData:data];
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)fetchTimelineForUser:(NSString *)screenname
{
    //Request access to the twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted,NSError *error){
             if (granted) {
                 
                 //  Step 2:  Create a request
                 NSArray *twitterAcct = [accountStore accountsWithAccountType:accountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : screenname,
                                          @"include_rts" : @"0",
                                          @"trim_user" : @"1",
                                          @"count" : @"1"};
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAcct lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                                 
                                 
                                 /* Display user timeline HERE !!! */
                                 
                                 
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

@end
