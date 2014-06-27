//
//  Hunt.h
//  Pods
//
//  Created by David Sweetman on 6/27/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HuntTarget;

@interface Hunt : NSManagedObject

@property (nonatomic, retain) UNKNOWN_TYPE title;
@property (nonatomic, retain) UNKNOWN_TYPE explanation;
@property (nonatomic, retain) HuntTarget *targets;

@end
