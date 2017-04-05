//
//  ECAttributeOption.m
//  Everlong
//
//  Created by Jason Cox on 11/30/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "ECAttributeOption.h"

@implementation ECAttributeOption
static RKObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;




@synthesize objID = _objID;
@synthesize option = _option;
//@synthesize price_modifier = _price_modifier; //This is only for ECOptions (which to the backend is the same thing)
@synthesize quantity = _quantity;
@synthesize is_sold_out = _is_sold_out;

//Address fields
@synthesize name = _name;
@synthesize address1 = _address1;
@synthesize address2 = _address2;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
//Input values
@synthesize inputValue = _inputValue;
@synthesize selectedValue = _selectedValue;

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"objID"];
        [objectMapping mapKeyPath:@"option" toAttribute:@"option"];
        //[objectMapping mapKeyPath:@"price_modifier" toAttribute:@"price_modifier"]; //This is only for ECOptions (which to the backend is the same thing)
        [objectMapping mapKeyPath:@"quantity" toAttribute:@"quantity"];
        [objectMapping mapKeyPath:@"is_sold_out" toAttribute:@"is_sold_out"];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping;
{
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        //serializationMapping.rootKeyPath = @"order";
        [serializationMapping mapKeyPath:@"objID" toAttribute:@"id"];
        [serializationMapping mapKeyPath:@"option" toAttribute:@"option"];
        //[serializationMapping mapKeyPath:@"price_modifier" toAttribute:@"price_modifier"]; //This is only for ECOptions (which to the backend is the same thing)
        [serializationMapping mapKeyPath:@"quantity" toAttribute:@"quantity"];
        [serializationMapping mapKeyPath:@"is_sold_out" toAttribute:@"is_sold_out"];        
    }
    return serializationMapping;
}

//TODO: FIX THE JSON ENCODE SO IT ACTULALY ENCODES
-(NSString *)addressJSON;
{
    return [NSString stringWithFormat:@"{\"name\":\"%@\",\"address\":\"%@\",\"apt\":\"%@\",\"city\":\"%@\",\"state\":\"%@\",\"zipcode\":\"%@\"}", self.name, self.address1, self.address2, self.city,self.state, self.zip];
}

@end
