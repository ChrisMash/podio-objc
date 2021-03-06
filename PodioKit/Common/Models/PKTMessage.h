//
//  PKTMessage.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 13/11/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"

@class PKTEmbed;

@interface PKTMessage : PKTModel

@property (nonatomic, readonly) NSUInteger messageID;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSArray *files;
@property (nonatomic, copy, readonly) PKTEmbed *embed;

@end
