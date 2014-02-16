//
//  DIOSErrorHandler.h
//  WalkthroughAcquia
//
//  Created by Zoltán Váradi on 8/29/13.
//  Copyright (c) 2013 Zoltán Váradi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIOSUserManager : NSObject

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

+ (void)generalAlertUserAboutError:(NSError*)error;

+ (void)loginAlertUserAboutError:(NSError*)error;

+ (void)registrationAlertUserAboutOnlineError:(NSError*)error;

+ (void)registrationAlertUserAboutOfflineError:(NSError*)error;

+ (BOOL)registrationValidateFormWithError:(NSError**)error
                        usernameTextField:(UITextField*) usernameTextField
                           emailTextField:(UITextField*) emailTextField
                        passwordTextField:(UITextField*) passwordTextField
            passwordVerificationTextField:(UITextField*) passwordVerificationTextField;
@end
