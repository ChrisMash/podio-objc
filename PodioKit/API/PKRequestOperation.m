//
//  PORequestOperation.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 9/12/11.
//  Copyright 2011 Podio. All rights reserved.
//

#import "PKRequestOperation.h"
#import "PKRequestResult.h"
#import "JSONKit.h"


// Exceptions
NSString * const PKNoObjectMapperSetException = @"PKNoObjectMapperSetException";

@interface PKRequestOperation ()

- (id)performMappingOfData:(id)data;

@end

@implementation PKRequestOperation

@synthesize objectMapper = objectMapper_;
@synthesize requestCompletionBlock = requestCompletionBlock_;

- (id)initWithURLString:(NSString *)urlString method:(NSString *)method {
  NSURL *requestURL = [NSURL URLWithString:urlString];
  self = [super initWithURL:requestURL];
  if (self) {
    self.requestMethod = method;
    objectMapper_ = nil;
    requestCompletionBlock_ = nil;
  }
  return self;
}

- (void)dealloc {
  [requestCompletionBlock_ release];
  requestCompletionBlock_ = nil;
  
  [objectMapper_ release];
  objectMapper_ = nil;
  
  [super dealloc];
}

+ (PKRequestOperation *)operationWithURLString:(NSString *)urlString 
                                        method:(NSString *)method 
                                          body:(id)body {
  PKRequestOperation *operation = [[[self alloc] initWithURLString:urlString method:method] autorelease];
  operation.validatesSecureCertificate = YES;
  operation.shouldAttemptPersistentConnection = NO;
  
  // Body
  if (body != nil) {
    [operation addRequestHeader: @"Content-Type" value: @"application/json"];
    
    NSError *error = nil;
    NSString *bodyString = [body JSONStringWithOptions:0 error:&error];
    if (error != nil) {
      NSLog(@"Failed to serialize request body data: %@, %@", error, [error userInfo]);
    }
    
    [operation appendPostData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  return operation;
}

// Request succeeded
- (void)requestFinished {
  
  if ([self isCancelled]) {
    // Cancelled
    [super requestFinished];
    return;
  }
  
  id resultData = nil;
  id parsedData = nil;
  NSError *requestError = nil;
  
  // Parse data
  switch (self.responseStatusCode) {
    case 200:
    case 201:
      POLogDebug(@"Request succeded with status code %d", self.responseStatusCode);
      //      POLogDebug(@"Response body: %@", data);
      
      NSError *parseError = nil;
      parsedData = [self.responseData objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode error:&parseError];
      
      if (parseError == nil) {
        // Should map response?
        if (self.objectMapper != nil) {
          resultData = [self performMappingOfData:parsedData];
        }
      } else {
        NSLog(@"Failed to parse response data: %@, %@", parseError, [parseError userInfo]);
        requestError = [NSError pk_responseParseError];      
      }
      break;
    case 204:
      // Success but no data
      POLogDebug(@"Request succeded with status code %d", self.responseStatusCode);
      break;
    default:
      // Failed
      POLogDebug(@"Request failed with status code %d: %@", self.responseStatusCode, self.responseString);
      requestError = [NSError pk_serverErrorWithStatusCode:self.responseStatusCode responseString:self.responseString];
      break;
  }
  
  PKRequestResult *result = [PKRequestResult resultWithResponseStatusCode:self.responseStatusCode 
                                                             responseData:self.responseData 
                                                               parsedData:parsedData 
                                                               resultData:resultData];
  
  // Completion handler on main thread
  if (self.requestCompletionBlock != nil) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      self.requestCompletionBlock(requestError, result);
    });
  }
  
  [super requestFinished];
}

// Request failed
- (void)failWithError:(NSError *)theError {
  
  if (![self isCancelled] && 
      !([[theError domain] isEqualToString:NetworkRequestErrorDomain] && [theError code] == ASIRequestCancelledErrorType)) { // Request cancelled
    
    POLogError(@"Request failed with code %d, %@, ", [self responseStatusCode], [self responseString]);
    POLogError(@"Request failed with error: %@, %@", [theError localizedDescription], [theError userInfo]);
    POLogError(@"Request debug info:\n  Method: %@\n  URL: %@\n  Headers: %@", [self requestMethod], [[self url] absoluteString], [self requestHeaders]);

    // Completion handler on main thread
    if (self.requestCompletionBlock != nil) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        self.requestCompletionBlock(error, nil);
      });
    }
  }
  
  [super failWithError:theError];
}

- (id)performMappingOfData:(id)data {
  
  if (self.objectMapper == nil) {
    NSString *msg = NSLocalizedString(@"No object mapper set, unable to perform mapping of response data.", nil);
    [NSException raise:PKNoObjectMapperSetException format:msg];
  }
  
  // Do mapping
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  id result = [[self.objectMapper performMappingWithData:data] retain];
  [pool drain];
  
  return [result autorelease];
}

@end
