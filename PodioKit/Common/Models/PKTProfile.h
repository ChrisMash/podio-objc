//
//  PKTProfile.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 28/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"
#import "PKTClient.h"

@interface PKTProfile : PKTModel

@property (nonatomic, assign, readonly) NSUInteger profileID;
@property (nonatomic, assign, readonly) NSUInteger userID;
@property (nonatomic, copy, readonly) NSString *name;

+ (PKTRequestTaskHandle *)fetchProfileWithID:(NSUInteger)profileID completion:(void (^)(PKTProfile *profile, NSError *error))completion;

+ (PKTRequestTaskHandle *)fetchProfileWithUserID:(NSUInteger)userID completion:(void (^)(PKTProfile *profile, NSError *error))completion;

+ (PKTRequestTaskHandle *)fetchProfilesWithIDs:(NSArray *)profileIDs completion:(void (^)(NSArray *profiles, NSError *error))completion;

@end
