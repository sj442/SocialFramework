//
//  TweetsViewController.m
//  SocialFramework
//
//  Created by Sunayna Jain on 2/18/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import "TweetsViewController.h"
#import <Accounts/ACAccountType.h>
#import "TweetObject.h"

@interface TweetsViewController ()

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) NSMutableArray *tweetsArray;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
    }
    return self;
}


-(BOOL)userHasAccessToTwitter{
    
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

-(void)fetchTimeLineForUser:(NSString*)username{
    
    self.accountStore = [[ACAccountStore alloc]init];
    
    NSLog(@"account store %@", [self.accountStore description]);
    
    if ([self userHasAccessToTwitter]){
        
       ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        NSLog(@"twitter account type %@", [twitterAccountType description]);
        
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            
            NSLog(@"request access to account type ... called");
            
            if (granted){
                
                NSLog(@"granted");
                
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                
                NSDictionary *params = @{@"screen_name":username, @"include_rts":@"0", @"trim_user":@"0",@"contributor_details":@"1", @"count":@"20"};
                
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                
                [request setAccount:[twitterAccounts lastObject]];
                
                NSLog(@"twitter account %@", [twitterAccounts lastObject]);
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData) {
                        if (urlResponse.statusCode >= 200 &&
                            urlResponse.statusCode < 300) {
                            
                            NSError *jsonError;
                            NSDictionary *timelineData =
                            [NSJSONSerialization
                             JSONObjectWithData:responseData
                             options:NSJSONReadingAllowFragments error:&jsonError];
                            if (timelineData) {
                                NSLog(@"Timeline Response: %@\n", timelineData);
                                
                                NSArray *timeLineArray = ((NSArray*)timelineData);
                                
                                self.tweetsArray = [[NSMutableArray alloc]initWithCapacity:[timeLineArray count]];
                                
                                for (int i=0; i<[timeLineArray count]; i++){
                                    
                                    NSString *name = timeLineArray[i][@"user"][@"name"];
                                    NSString *screenName = timeLineArray[i][@"user"][@"screen_name"];
                                    NSString *text = timeLineArray[i][@"text"];
                                    
                                    TweetObject *newTweet = [[TweetObject alloc]initWithName:name ansSCreenName:screenName andText:text];
                                    
                                    [self.tweetsArray addObject:newTweet];
                                }
                            }
                            else {
                                // Our JSON deserialization went awry
                                NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            }
                        }
                        else {
                            // The server did not respond ... were we rate-limited?
                            NSLog(@"The response status code is %d",
                                  urlResponse.statusCode);
                        }
                    }
                }];
            }
            else {
                
                NSLog(@"access was not granted");
                // Access was not granted, or an error occurred
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"got here");
    
    [self userHasAccessToTwitter];
    
    [self fetchTimeLineForUser:@"jainsunayna"];
    
    self.tweetsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
    
    [self.view addSubview:self.tweetsTableView];
    
	// Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweetsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tweetCell"];
    }
    
    NSString *name = ((TweetObject*)self.tweetsArray[indexPath.row]).name;
    
    NSString *screenName = ((TweetObject*)self.tweetsArray[indexPath.row]).screenNmae;
    
    NSString *text = ((TweetObject*)self.tweetsArray[indexPath.row]).text;

    NSString *combinedText = [NSString stringWithFormat:@"%@ @%@ %@", name, screenName, text];

    cell.textLabel.text = combinedText;
    
    return cell;
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
