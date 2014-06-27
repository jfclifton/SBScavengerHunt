//
//  Hunt_To.m
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

#import "Hunt+Tools.h"
#import "HuntTarget.h"

@implementation Hunt (Tools)

- (NSData*)jsonData
{
    NSMutableArray *targets = [[NSMutableArray alloc] init];
    for (HuntTarget *target in self.targets) {
        NSDictionary *targetDict = @{@"proximityUUID" : target.proximity,
                                     @"major" : target.major,
                                     @"minor" : target.minor,
                                     @"tooFar" : target.descOutOfRange,
                                     @"far" : target.descFar,
                                     @"near" : target.descNear,
                                     @"immediate" : target.descImmediate};
        [targets addObject:targetDict];
    }
    NSDictionary *exportDict = @{
                                 @"hunt" : self.title,
                                 @"description" : self.huntDescription,
                                 @"targets" : targets
                                 };
    return [NSJSONSerialization dataWithJSONObject:exportDict options:0 error:nil];
}

@end
