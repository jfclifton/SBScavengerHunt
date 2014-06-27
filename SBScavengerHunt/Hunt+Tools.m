//
//  Hunt_To.m
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

#import "Hunt+Tools.h"

@implementation Hunt (Tools)

- (NSString*)jsonValue
{
    NSDictionary *exportDict = @{
                                 @"hunt" : self.title,
                                 @"description" : self.huntDescription,
                                 @"targets" : [self.targets array]
                                 };
    NSData *json = [NSJSONSerialization dataWithJSONObject:exportDict options:0 error:nil];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

@end
