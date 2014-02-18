//
//  TweetObject.h
//  SocialFramework
//
//  Created by Sunayna Jain on 2/18/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenNmae;
@property (strong, nonatomic) NSString *text;

-(id)initWithName:(NSString*)name ansSCreenName:(NSString*)screenName andText:(NSString*)text;


@end
