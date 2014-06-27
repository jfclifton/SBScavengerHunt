//
//  HuntTarget.h
//  Pods
//
//  Created by David Sweetman on 6/27/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HuntTarget : NSManagedObject

@property (nonatomic, retain) UNKNOWN_TYPE title;
@property (nonatomic, retain) UNKNOWN_TYPE par;
@property (nonatomic, retain) UNKNOWN_TYPE descOutOfRange;
@property (nonatomic, retain) UNKNOWN_TYPE descFar;
@property (nonatomic, retain) UNKNOWN_TYPE descNear;
@property (nonatomic, retain) UNKNOWN_TYPE descImmediate;
@property (nonatomic, retain) NSManagedObject *hunt;

@end
