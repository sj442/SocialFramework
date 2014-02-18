//
//  TweetObject.m
//  SocialFramework
//
//  Created by Sunayna Jain on 2/18/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import "TweetObject.h"

@implementation TweetObject


-(id)initWithName:(NSString*)name ansSCreenName:(NSString*)screenName andText:(NSString*)text{
    
    self = [super init];
    
    if (self){
        
        self.name =name;
        self.screenNmae= screenName;
        self.text = text;
    }
    
    return self;
}

@end
