//
//  Hunt_To.m
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

#import "Hunt+Tools.h"

@implementation Hunt (Tools)

- (NSData*)jsonData
{
    NSDictionary *exportDict = @{
                                 @"hunt" : self.title,
                                 @"description" : self.huntDescription,
                                 @"targets" : (self.targets.count ? [self.targets array] : @"")
                                 };
    return [NSJSONSerialization dataWithJSONObject:exportDict options:0 error:nil];
}

@end
