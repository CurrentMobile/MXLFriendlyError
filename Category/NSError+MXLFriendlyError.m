//
//  NSError+MXLFriendlyError.m
//  FriendlyError
//
//  Created by John Welch on 10/16/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//

#import "NSError+MXLFriendlyError.h"

//#include <map>
//#include <string>

const NSString *MXLFriendlyErrorDomain = @"MXLFriendlyErrorsDomain";

//static std::map<std::string, std::map<errorCodeRange, NSString *> > _friendlyErrorDescription;

static NSDictionary *_friendlyErrorDescription;

@implementation NSError (MXLFriendlyError)

+ (void)initialize {
    [self loadFriendlyErrorDescriptions];
}

+ (void)loadFriendlyErrorDescriptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"plist"];
    NSDictionary *descriptions  = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    _friendlyErrorDescription = descriptions;
    
    // The format for the error plist is an array of arrays containing (domain,startcode,endcode,description).
    // Parse that into something efficient to search.
    /*
    for (NSString *key in descriptions) {
        
        std::string locale = std::string([key UTF8String]);
        
        NSArray *errors = descriptions[key];
        
        for (NSArray *error in errors) {
            errorCodeRange range = errorCodeRange([error[0] integerValue],[error[1] integerValue]);
            NSString *description = error[2];
            
            _friendlyErrorDescription[locale][range] = description;
        }
    }
    */
}

+ (NSString *)friendlyLocalizedDescriptionHTTPStatus:(NSInteger)statusCode {
    
    NSLocale *locale = [NSLocale currentLocale];

    NSString *localeID = locale.localeIdentifier;
    
    /*
    NSString *description = _friendlyErrorDescription[std::string([locale UTF8String])][errorCodeRange(statusCode)];
    
    if (description == nil) {
        description = _friendlyErrorDescription[std::string("en_US")][errorCodeRange(statusCode)];
    }
    */
    
    NSString *description = nil;
    
    NSArray *errorRanges = _friendlyErrorDescription[localeID];
    
    if (errorRanges == nil) {
        errorRanges = _friendlyErrorDescription[@"en_US"];
    }
    
    NSInteger index = 0;
    NSInteger count = [errorRanges count];
    
    while (index < count && description == nil) {
        NSArray *item = errorRanges[index];
        
        if ([item[0] integerValue] <= statusCode && [item[1] integerValue] >= statusCode) {
            description = item[2];
        }
        
        index += 1;
    }
    
    return description;
}

+ (NSError *)errorWithStatus:(NSInteger)statusCode andDomain:(NSString *)domain andDefaultDescription:(NSString *)description {
    NSString *friendlyDescription = [NSError friendlyLocalizedDescriptionHTTPStatus:statusCode];
    NSDictionary *info = nil;
    
    if (friendlyDescription != nil) {
        info = @{NSLocalizedDescriptionKey: friendlyDescription};
    } else {
        info = @{NSLocalizedDescriptionKey: description};
    }
    
    return [NSError errorWithDomain:domain code:statusCode userInfo:info];
}

// Implement this later. For now, pass the localized description.
- (NSString *)friendlyLocalizedDescription {
    
    return [self localizedDescription];
}


@end
