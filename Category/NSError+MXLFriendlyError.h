//
//  NSError+FriendlyError.h
//  FriendlyError
//
//  Created by John Welch on 10/16/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//
//  This category adds the ability to provide custom HTTP error descriptions
//  specific to a locale or defaulting to US English.

#import <Foundation/Foundation.h>

// An error domain for friendly errors.
extern const NSString *MXLFriendlyErrorDomain;

@interface NSError (MXLFriendlyError)

+ (void)loadFriendlyErrorDescriptions;

/**
    This method returns a customized user message for a given HTTP status code.
 
    @return
    The customized error message or nil if no description available.
 */
+ (NSString *)friendlyLocalizedDescriptionHTTPStatus:(NSInteger)statusCode;

/**
    A convenience constructor for creating error objects from HTTP status codes.
 
    @param statusCode
    An HTTP response status code.
    @param description
    A fallback description for when a friendly message is unavailable.
    @return
    An error object with the
 */
+ (NSError *)errorWithStatus:(NSInteger)statusCode andDomain:(NSString *)domain andDefaultDescription:(NSString *)description;

/**
    This method returns a customized user message for the error, if available
    otherwise returning the standard localized description.
 
    @return
    A localized error description string.
 */
- (NSString *)friendlyLocalizedDescription;

@end
