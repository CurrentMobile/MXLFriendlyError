//
//  NSError+MXLFriendlyError.m
//  FriendlyError
//
//  Created by John Welch on 10/16/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//

#import "NSError+MXLFriendlyError.h"

#import <objc/runtime.h>

#include <map>
#include <string>

class errorCodeRange {
public:
    NSInteger min;
    NSInteger max;
    
    errorCodeRange(NSInteger min, NSInteger max)
    {
        this->min = min;
        this->max = max;
    };
    
    errorCodeRange(NSInteger val)
    {
        this->min = val;
        this->max = val;
    };
    
    const bool operator < ( const errorCodeRange &rhs ) const
    {
        // rhs range is greater
        return rhs.min > max;
    }
};

static std::map<std::string, std::map<errorCodeRange, NSString *> > _friendlyErrorDescription;

static std::map<errorCodeRange, NSString *> _testMap;

@implementation NSError (MXLFriendlyError)

+ (void)initialize {
    [self loadFriendlyErrorDescriptions];
}

+ (void)loadFriendlyErrorDescriptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"plist"];
    NSDictionary *descriptions  = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // The format for the error plist is an array of arrays containing (domain,startcode,endcode,description).
    // Parse that into something efficient to search.
    for (NSString *key in descriptions) {
        
        std::string locale = std::string([key UTF8String]);
        
        NSArray *errors = descriptions[key];
        
        for (NSArray *error in errors) {
            errorCodeRange range = errorCodeRange([error[0] integerValue],[error[1] integerValue]);
            NSString *description = error[2];
            
            _friendlyErrorDescription[locale][range] = description;
        }
    }
}

+ (NSString *)friendlyLocalizedDescriptionHTTPStatus:(NSInteger)statusCode {
    
    NSString *locale = [NSLocale currentLocale].localeIdentifier;
    
    NSString *description = _friendlyErrorDescription[std::string([locale UTF8String])][errorCodeRange(statusCode)];
    
    if (description == nil) {
        description = _friendlyErrorDescription[std::string("en_US")][errorCodeRange(statusCode)];
    }
    
    return description;
}

// Implement this later. For now, pass the localized description.
- (NSString *)friendlyLocalizedDescription {
    
    return [self localizedDescription];
}


@end
