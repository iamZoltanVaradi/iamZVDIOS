//
//  Utilities.m
//
//  Created by Zoltán Váradi on 3/11/13.
//  Copyright (c) 2013 Zoltán Váradi. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
   
   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle: title
                            message: message
                            delegate: nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil];
      [alert show];
   }];
}
@end
