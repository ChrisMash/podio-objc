//
//  UIImageView+PKTRemoteImage.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 25/06/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//


#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <objc/runtime.h>
#import "UIImageView+PKTRemoteImage.h"
#import "PKTImageDownloader.h"
#import "PKTMacros.h"
#import "PKTRequestTaskHandle.h"

static const char kCurrentImageTaskKey;

@interface UIImageView ()

@property (nonatomic, strong, setter = pkt_setCurrentImageTask:) PKTRequestTaskHandle *pkt_currentImageTask;

@end

@implementation UIImageView (PKTRemoteImage)

- (PKTRequestTaskHandle *)pkt_currentImageTask {
  return objc_getAssociatedObject(self, &kCurrentImageTaskKey);
}

- (void)pkt_setCurrentImageTask:(PKTRequestTaskHandle *)pkt_currentImageTask {
  objc_setAssociatedObject(self, &kCurrentImageTaskKey, pkt_currentImageTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (void)pkt_setImageWithFile:(PKTFile *)file placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *image, NSError *error))completion {
  [self pkt_cancelCurrentImageDownload];
  
  PKT_WEAK_SELF weakSelf = self;
  self.pkt_currentImageTask = [PKTImageDownloader setImageWithFile:file placeholderImage:placeholderImage imageSetterBlock:^(UIImage *image) {
    weakSelf.image = image;
  } completion:^(UIImage *image, NSError *error) {
    weakSelf.pkt_currentImageTask = nil;
    
    if (completion) completion(image, error);
  }];
}

- (void)pkt_cancelCurrentImageDownload {
  [self.pkt_currentImageTask cancel];
  self.pkt_currentImageTask = nil;
}

@end

#endif
