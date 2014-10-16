//
//  NSError+MXLFriendlyError.m
//
//  Created by John Welch on 10/16/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//

#import "NSError+MXLFriendlyError.h"

#import <objc/runtime.h>

#include <map>
#include <string>

// A quick and dirty range object.. Look up a range class in the C++ docs.
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

+ (void)loadFriendlyErrorDescriptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"plist"];
    NSArray *descriptions  = [[NSArray alloc] initWithContentsOfFile:path];
    
    // The format for the error plist is an array of arrays containing (domain,startcode,endcode,description).
    // Parse that into something efficient to search.
    for (NSArray *d in descriptions) {
        NSString *domain = d[0];
        errorCodeRange range = errorCodeRange([d[1] integerValue],[d[2] integerValue]);
        NSString *description = d[3];
        
        _friendlyErrorDescription[std::string([domain UTF8String])][range] = description;
        
    }
}

- (NSString *)friendlyLocalizedDescription {

    NSString *description = _friendlyErrorDescription[std::string([self.domain UTF8String])][errorCodeRange(self.code)];
    
    if (description == nil) {
        description = [self localizedDescription];
    }
    
    return description;
}


@end
