//
//  TweetsViewController.h
//  SocialFramework
//
//  Created by Sunayna Jain on 2/18/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface TweetsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tweetsTableView;

@end
