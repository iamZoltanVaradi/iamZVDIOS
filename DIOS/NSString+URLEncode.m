//
//  NSString+URLEncode.m
//  ORCoffeeRoaster
//
//  Created by Zoltán Váradi on 10/14/13.
//  Copyright (c) 2013 Zoltán Váradi. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (NSString_URLEncode)

- (NSString *)urlencode {
   NSMutableString *output = [NSMutableString string];
   const unsigned char *source = (const unsigned char *)[self UTF8String];
   int sourceLen = strlen((const char *)source);
   for (int i = 0; i < sourceLen; ++i) {
      const unsigned char thisChar = source[i];
      if (thisChar == ' '){
         [output appendString:@"+"];
      } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                 (thisChar >= 'a' && thisChar <= 'z') ||
                 (thisChar >= 'A' && thisChar <= 'Z') ||
                 (thisChar >= '0' && thisChar <= '9')) {
         [output appendFormat:@"%c", thisChar];
      } else {
         [output appendFormat:@"%%%02X", thisChar];
      }
   }
   return output;
}

@end
