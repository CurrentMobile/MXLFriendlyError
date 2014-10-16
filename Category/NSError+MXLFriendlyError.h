//
//  NSError+FriendlyError.h
//
//  Created by John Welch on 10/16/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//
//  Adds a method to NSError that returns a customized error description.
//  To start with, we read from an error plist. The loading will get smarter
//  as we figure out how to use it.

#import <Foundation/Foundation.h>

@interface NSError (MXLFriendlyError)

/**
   Load the custom error descriptions into memory.

*/
+ (void)loadFriendlyErrorDescriptions;

/**
    This method returns a customized user message for a given error.
 
    @return
    The customized error message or the localized description if no custom error available.
 */
- (NSString *)friendlyLocalizedDescription;

@end
