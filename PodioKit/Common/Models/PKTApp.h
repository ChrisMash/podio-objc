//
//  PKTApp.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 03/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"

@class PKTAppField, PKTRequestTaskHandle;

@interface PKTApp : PKTModel

@property (nonatomic, readonly) NSUInteger appID;
@property (nonatomic, readonly) NSUInteger spaceID;
@property (nonatomic, readonly) NSUInteger iconID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *itemName;
@property (nonatomic, copy, readonly) NSString *appDescription;
@property (nonatomic, copy, readonly) NSURL *link;
@property (nonatomic, copy, readonly) NSArray *fields;

+ (PKTRequestTaskHandle *)fetchAppWithID:(NSUInteger)appID completion:(void (^)(PKTApp *app, NSError *error))completion;
+ (PKTRequestTaskHandle *)fetchAppsInWorkspaceWithID:(NSUInteger)spaceID completion:(void (^)(NSArray *apps, NSError *error))completion;

- (PKTAppField *)fieldWithExternalID:(NSString *)externalID;

@end