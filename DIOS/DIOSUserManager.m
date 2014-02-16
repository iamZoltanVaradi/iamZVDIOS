//
//  DIOSErrorHandler.m
//  WalkthroughAcquia
//
//  Created by Zoltán Váradi on 8/29/13.
//  Copyright (c) 2013 Zoltán Váradi. All rights reserved.
//

#import "DIOSUserManager.h"
#import "DIOSUser.h"

@implementation DIOSUserManager

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

+ (void)generalAlertUserAboutError:(NSError*)error
{
   NSString* nsLocalizedRecoverySuggestion = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
   
   if(error.code == -1009) {
      
      [self showAlertWithTitle:NSLocalizedString(@"GeneralErrorTitle", nil)
                       message:NSLocalizedString(@"NoInternet", nil)];
      return;
   }
   
   else if(!nsLocalizedRecoverySuggestion) {
      
      [self showAlertWithTitle:NSLocalizedString(@"GeneralErrorTitle", nil)
                       message:NSLocalizedString(@"GeneralError", nil)];
      return;
   }
   
   else if(error.code == -1001) {
      
      [self showAlertWithTitle:NSLocalizedString(@"GeneralErrorTitle", nil)
                       message:NSLocalizedString(@"ConnectionTimeOut", nil)];
   }
   
   else {
      
      [self showAlertWithTitle:NSLocalizedString(@"GeneralErrorTitle", nil)
                       message:NSLocalizedString(@"GeneralError", nil)];
      return;
   }
   
}

+ (void)loginAlertUserAboutError:(NSError*)error
{
   NSString* nsLocalizedRecoverySuggestion = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
   
   if(error.code == -1009) {
      
      [self showAlertWithTitle:NSLocalizedString(@"LoginErrorTitle", nil)
                       message:NSLocalizedString(@"NoInternet", nil)];
      return;
   }
   
   else if(error.code == -1001) {
      
      [self showAlertWithTitle:NSLocalizedString(@"LoginErrorTitle", nil)
                       message:NSLocalizedString(@"ConnectionTimeOut", nil)];
   }
   
   else if(!nsLocalizedRecoverySuggestion) {
      
      [self showAlertWithTitle:NSLocalizedString(@"LoginErrorTitle", nil)
                       message:NSLocalizedString(@"GeneralLoginError", nil)];
      return;
   }
   
   else if([nsLocalizedRecoverySuggestion rangeOfString:@"Wrong username or password."].location != NSNotFound) {
      
      [self showAlertWithTitle:NSLocalizedString(@"LoginErrorTitle", nil)
                       message:NSLocalizedString(@"LoginErrorMessage", nil)];
      return;
   }
   
   else {
      
      [self showAlertWithTitle:NSLocalizedString(@"LoginErrorTitle", nil)
                       message:NSLocalizedString(@"GeneralLoginError", nil)];
      return;
   }
   
}

+ (void)registrationAlertUserAboutOnlineError:(NSError*)error
{
   
   NSString* nsLocalizedRecoverySuggestion = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
   
   if(error.code == -1009) {
      
      [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                       message:NSLocalizedString(@"NoInternetConnection", nil)];
   }
   
   else if(error.code == -1001) {
      
      [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                       message:NSLocalizedString(@"ConnectionTimeOut", nil)];
   }
   
   
   else if(nsLocalizedRecoverySuggestion != nil) {
      
      if([nsLocalizedRecoverySuggestion rangeOfString:@"is already taken."].location != NSNotFound) {
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"UsernameTaken", nil)];
         
      }
      
      else if([nsLocalizedRecoverySuggestion rangeOfString:@"is already registered."].location != NSNotFound) {
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"EmailTaken", nil)];
         
      }
   }
   else {
      
      [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                       message:NSLocalizedString(@"GeneralError", nil)];
      
   }
   NSLog(@"Registration failure in %s : %@", __FUNCTION__, [error description]);
}

+ (void)registrationAlertUserAboutOfflineError:(NSError*)error
{
   NSString* errorKind = [error.userInfo valueForKey:@"ErrorKind"];
   
   if (errorKind && ![errorKind isEqualToString:@""]) {
      
      if([errorKind isEqualToString:@"UserNameEmptyOrNil"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"UserNameEmptyOrNil", nil)];
      
      else if([errorKind isEqualToString:@"UserNameInUnacceptableFormat"]) {
         
         NSString* errorDescription = [error.userInfo valueForKey:@"ErrorDescription"];
         NSString* localizedErrorDescription = NSLocalizedString(errorDescription, nil);
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(localizedErrorDescription, nil)];
      }
      
      else if([errorKind isEqualToString:@"EmailEmptyOrNil"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"EmailEmptyOrNil", nil)];
      
      else if([errorKind isEqualToString:@"EmailInUnAcceptableFormat"]) {
         
         NSString* errorDescription = [error.userInfo valueForKey:@"ErrorDescription"];
         NSString* localizedErrorDescription = NSLocalizedString(errorDescription, nil);
         
         NSLog(@"errorDescription: %@", errorDescription);
         NSLog(@"localizedErrorDescription: %@", localizedErrorDescription);
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(localizedErrorDescription, nil)];
      }
      
      
      else if([errorKind isEqualToString:@"PasswordEmptyOrNil"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"PasswordEmptyOrNil", nil)];
      
      
      else if([errorKind isEqualToString:@"PasswordTooShort"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"PasswordTooShort", nil)];
      
      
      else if([errorKind isEqualToString:@"PasswordTooShort"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"PasswordTooShort", nil)];
      
      
      else if([errorKind isEqualToString:@"PasswordVerificationEmptyOrNil"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"PasswordVerificationEmptyOrNil", nil)];
      
      
      else if([errorKind isEqualToString:@"PasswordsDontMatch"])
         
         [self showAlertWithTitle:NSLocalizedString(@"RegistrationErrorTitle", nil)
                          message:NSLocalizedString(@"PasswordsDontMatch", nil)];
      
   }
   
   
}

+ (BOOL)registrationValidateFormWithError:(NSError**)error
                        usernameTextField:(UITextField*) usernameTextField
                           emailTextField:(UITextField*) emailTextField
                        passwordTextField:(UITextField*) passwordTextField
            passwordVerificationTextField:(UITextField*) passwordVerificationTextField

{
   
   NSMutableDictionary* details = [[NSMutableDictionary alloc]init];
   NSError* nameError = nil;
   NSError* emailError = nil;
   
   if(!usernameTextField.text || [usernameTextField.text isEqualToString:@""]) {
      
      [details setValue:@"Please enter your desired username." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameEmptyOrNil" forKey:@"ErrorKind"];
   }
   
   else if(![DIOSUser userValidateUserName:usernameTextField.text error:&nameError]) {
      
      [details setValue:[NSString stringWithFormat:@"Your desired username is not in an acceptable format, reason: %@", [nameError.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]] forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameInUnacceptableFormat" forKey:@"ErrorKind"];
      [details setValue:[nameError.userInfo valueForKey:@"ErrorKind"] forKey:@"ErrorDescription"];
   }
   
   else if(!emailTextField.text || [emailTextField.text isEqualToString:@""]) {
      
      [details setValue:@"Please enter your e-mail address." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"EmailEmptyOrNil" forKey:@"ErrorKind"];
   }
   
   else if(![DIOSUser userValidateUserEmail:emailTextField.text error:&emailError]) {
      
      [details setValue:[NSString stringWithFormat:@"%@", [emailError.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]] forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"EmailInUnAcceptableFormat" forKey:@"ErrorKind"];
      [details setValue:[emailError.userInfo valueForKey:@"ErrorKind"] forKey:@"ErrorDescription"];
      
   }
   
   else if(!passwordTextField.text || [passwordTextField.text isEqualToString:@""]) {
      
      [details setValue:@"Please enter your desired password." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"PasswordEmptyOrNil" forKey:@"ErrorKind"];
   }
   
   else if(passwordTextField.text.length < 6) {
      
      [details setValue:@"Your password has to be at least 6 characters long." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"PasswordTooShort" forKey:@"ErrorKind"];
   }
   
   else if(!passwordVerificationTextField.text || [passwordVerificationTextField.text isEqualToString:@""]) {
      
      [details setValue:@"Please provide the password vericifation." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"PasswordVerificationEmptyOrNil" forKey:@"ErrorKind"];
   }
   
   else if(![passwordTextField.text isEqualToString:passwordVerificationTextField.text]) {
      
      [details setValue:@"Your given password and password verification don’t match." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"PasswordsDontMatch" forKey:@"ErrorKind"];
   }
   
   if([details objectForKey:@"NSLocalizedRecoverySuggestion"]) {
      
      [details setValue:@"Unaccordingly filled registration form" forKey:NSLocalizedDescriptionKey];
      
      if (error != NULL)
         *error = [NSError errorWithDomain:@"registrationForm" code:400 userInfo:details];
      
      return NO;
   }
   
   return YES;
}




@end
