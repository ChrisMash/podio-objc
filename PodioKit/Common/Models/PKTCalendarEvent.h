//
//  PKTCalendarEvent.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 08/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"
#import "PKTConstants.h"

@class PKTApp, PKTRequestTaskHandle;

@interface PKTCalendarEvent : PKTModel

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *descr;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *UID;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSDate *endDate;
@property (nonatomic, copy, readonly) NSURL *linkURL;
@property (nonatomic, copy, readonly) PKTApp *app;
@property (nonatomic, assign, readonly) BOOL busy;
@property (nonatomic, assign, readonly) PKTReferenceType referenceType;
@property (nonatomic, assign, readonly) NSUInteger referenceID;

#pragma mark - API

+ (PKTRequestTaskHandle *)fetchAllFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate completion:(void (^)(NSArray *events, NSError *error))completion;
+ (PKTRequestTaskHandle *)fetchAllFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate priority:(NSUInteger)priority completion:(void (^)(NSArray *events, NSError *error))completion;

@end