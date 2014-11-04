//
//  PKTConversation.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 02/11/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"

@class PKTAsyncTask;

@interface PKTConversation : PKTModel

@property (nonatomic, readonly) NSUInteger conversationID;
@property (nonatomic, copy, readonly) NSString *subject;
@property (nonatomic, copy, readonly) NSString *excerpt;
@property (nonatomic, copy, readonly) NSDate *createdOn;
@property (nonatomic, copy, readonly) NSDate *lastEventOn;
@property (nonatomic, copy, readonly) NSArray *participants;

+ (PKTAsyncTask *)fetchAllWithOffset:(NSUInteger)offset limit:(NSUInteger)limit;

@end