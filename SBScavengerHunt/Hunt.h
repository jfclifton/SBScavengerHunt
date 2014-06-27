//
//  Hunt.h
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Hunt : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * huntDescription;
@property (nonatomic, retain) NSOrderedSet *targets;
@end

@interface Hunt (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inTargetsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTargetsAtIndex:(NSUInteger)idx;
- (void)insertTargets:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTargetsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTargetsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceTargetsAtIndexes:(NSIndexSet *)indexes withTargets:(NSArray *)values;
- (void)addTargetsObject:(NSManagedObject *)value;
- (void)removeTargetsObject:(NSManagedObject *)value;
- (void)addTargets:(NSOrderedSet *)values;
- (void)removeTargets:(NSOrderedSet *)values;
@end
