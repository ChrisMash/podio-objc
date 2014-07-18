//
//  PKTOrganization.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 12/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"

@class PKTFile, PKTRequestTaskHandle;

@interface PKTOrganization : PKTModel

@property (nonatomic, assign, readonly) NSUInteger organizationID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSArray *workspaces;
@property (nonatomic, strong, readonly) PKTFile *imageFile;

#pragma mark - API

+ (PKTRequestTaskHandle *)fetchAllWithCompletion:(void (^)(NSArray *organizations, NSError *error))completion;
+ (PKTRequestTaskHandle *)fetchWithID:(NSUInteger)organizationID completion:(void (^)(PKTOrganization *organization, NSError *error))completion;

@end