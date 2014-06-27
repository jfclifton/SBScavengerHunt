//
//  HuntTarget.h
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hunt;

@interface HuntTarget : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descOutOfRange;
@property (nonatomic, retain) NSString * descFar;
@property (nonatomic, retain) NSString * descNear;
@property (nonatomic, retain) NSString * descImmediate;
@property (nonatomic, retain) NSNumber * par;
@property (nonatomic, retain) NSString * proximity;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, retain) Hunt *hunt;

@end
