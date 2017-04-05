//
//  ECAttribute.m
//  Everlong
//
//  Created by Jason Cox on 9/27/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "ECAttribute.h"
#import "ECAttributeOption.h"

@implementation ECAttribute
static RKObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@synthesize objID = _objID;
@synthesize type = _type;
@synthesize name = _name;
@synthesize stringDescription = _stringDescription;
@synthesize options = _options;

@synthesize attributeType = _attributeType;

@synthesize selectedOption = _selectedOption;


+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"objID"];
        [objectMapping mapKeyPath:@"type" toAttribute:@"type"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"description" toAttribute:@"stringDescription"];
        [objectMapping mapKeyPath:@"options" toRelationship:@"options" withMapping:[ECAttributeOption objectMapping]];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping;
{
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        //serializationMapping.rootKeyPath = @"order";
        [serializationMapping mapKeyPath:@"objID" toAttribute:@"id"];
        [serializationMapping mapKeyPath:@"type" toAttribute:@"type"];
        [serializationMapping mapKeyPath:@"name" toAttribute:@"name"];
        [serializationMapping mapKeyPath:@"stringDescription" toAttribute:@"description"];        
        [serializationMapping mapKeyPath:@"options" toRelationship:@"options" withMapping:[ECAttributeOption objectMapping] serialize:YES];
    }
    return serializationMapping;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Mapper failed for attribute. error: %@", error.localizedDescription);
}

-(AttributeType)attributeType;
{
    if([self.type isEqualToString:@"input"]){
        return AttributeTypeInput;
    }
    if([self.type isEqualToString:@"address"]){
        return AttributeTypeAddress;
    }
    if([self.type isEqualToString:@"select"]){
        return AttributeTypeSelect;
    }
    return AttributeTypeInput;
}

@end
