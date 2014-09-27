//
//  PKTItemFieldTests.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 27/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PKTItemField.h"
#import "PKTItemField+PKTTest.h"
#import "PKTNumberItemFieldValue.h"
#import "PKTStringItemFieldValue.h"
#import "PKTFileItemFieldValue.h"
#import "PKTAppItemFieldValue.h"
#import "PKTDateItemFieldValue.h"
#import "PKTProfileItemFieldValue.h"
#import "PKTMoneyItemFieldValue.h"
#import "PKTDurationItemFieldValue.h"
#import "PKTEmbedItemFieldValue.h"
#import "PKTCalculationItemFieldValue.h"
#import "PKTCategoryItemFieldValue.h"
#import "PKTLocationItemFieldValue.h"
#import "PKTAppFieldConfig.h"
#import "PKTCategoryOption.h"
#import "PKTDateRange.h"

@interface PKTItemFieldTests : XCTestCase

@end

@implementation PKTItemFieldTests

- (void)testInitWithAppField {
  PKTAppField *appField = [[PKTAppField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
  PKTItemField *itemField = [[PKTItemField alloc] initWithAppField:appField basicValues:@[@"Some text"]];
  
  expect(itemField.fieldID).to.equal(123);
  expect(itemField.externalID).to.equal(@"title");
  expect(itemField.type).to.equal(PKTAppFieldTypeText);
}

- (void)testSetValues {
  PKTItemField *field = [[PKTItemField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
  [field setValues:@[@"First value", @"Second value"]];
  
  expect(field.values).to.haveCountOf(2);
  expect(field.values[0]).to.equal(@"First value");
  expect(field.values[1]).to.equal(@"Second value");
}

- (void)testSetFirstValue {
  PKTItemField *field = [[PKTItemField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
  field.value = @"Some text";
  
  expect(field.values).to.haveCountOf(1);
  expect(field.value).to.equal(@"Some text");
}

- (void)testAddValue {
  PKTItemField *field = [[PKTItemField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
   [field addValue:@"First value"];
  [field addValue:@"Second value"];
  
  expect(field.values).to.haveCountOf(2);
  expect(field.values[0]).to.equal(@"First value");
  expect(field.values[1]).to.equal(@"Second value");
}

- (void)testRemoveValue {
  PKTItemField *field = [[PKTItemField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
  [field addValue:@"First value"];
  [field addValue:@"Second value"];
  
  [field removeValue:@"First value"];
  
  expect(field.values).to.haveCountOf(1);
  expect(field.values[0]).to.equal(@"Second value");
}

- (void)testRemoveValueAtIndex {
  PKTItemField *field = [[PKTItemField alloc] initWithFieldID:123 externalID:@"title" type:PKTAppFieldTypeText config:nil];
  [field addValue:@"First value"];
  [field addValue:@"Second value"];
  
  [field removeValueAtIndex:0];
  
  expect(field.values).to.haveCountOf(1);
  expect(field.values[0]).to.equal(@"Second value");
}

- (void)testValueClassForFieldType {
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeText]).to.equal([PKTStringItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeNumber]).to.equal([PKTNumberItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeImage]).to.equal([PKTFileItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeDate]).to.equal([PKTDateItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeApp]).to.equal([PKTAppItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeContact]).to.equal([PKTProfileItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeMoney]).to.equal([PKTMoneyItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeProgress]).to.equal([PKTNumberItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeLocation]).to.equal([PKTLocationItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeDuration]).to.equal([PKTDurationItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeEmbed]).to.equal([PKTEmbedItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeCalculation]).to.equal([PKTCalculationItemFieldValue class]);
  expect([PKTItemField valueClassForFieldType:PKTAppFieldTypeCategory]).to.equal([PKTCategoryItemFieldValue class]);
}

- (void)testUnboxedValueForBasicValueWithCategoryID {
  NSDictionary *settings = @{@"options" : @[
    @{
      @"status" : @"active",
      @"id" : @1,
      @"text" : @"First category",
      @"color" : @"ff0000",
    },
    @{
      @"status" : @"active",
      @"id" : @2,
      @"text" : @"Second category",
      @"color" : @"00ff00",
    }
  ]};

  PKTAppFieldConfig *config = [[PKTAppFieldConfig alloc] initWithLabel:@"category"
                                                           description:nil
                                                              settings:settings
                                                                 delta:1
                                                               mapping:PKTAppFieldMappingNone
                                                            isRequired:NO
                                                             isVisible:YES];

  PKTAppField *field = [[PKTAppField alloc] initWithFieldID:123 externalID:@"category" type:PKTAppFieldTypeCategory config:config];

  id value = [PKTItemField unboxedValueFromBasicValue:@2 forField:field];
  expect(value).to.beInstanceOf([PKTCategoryOption class]);
  expect([value optionID]).to.equal(2);
  expect([value status]).to.equal(PKTCategoryOptionStatusActive);
  expect([value text]).to.equal(@"Second category");
  expect([value color]).to.equal(@"00ff00");
}

- (void)testUnboxedValueForBasicValueWithDate {
  PKTAppField *field = [[PKTAppField alloc] initWithFieldID:123 externalID:@"date" type:PKTAppFieldTypeDate config:nil];

  NSDate *nowDate = [NSDate date];
  id value = [PKTItemField unboxedValueFromBasicValue:nowDate forField:field];

  expect(value).to.beInstanceOf([PKTDateRange class]);
  expect([value startDate]).to.equal(nowDate);
}

@end
