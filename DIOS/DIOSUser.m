//
//  DIOSUser.m
//
// ***** BEGIN LICENSE BLOCK *****
// Version: MPL 1.1/GPL 2.0
//
// The contents of this file are subject to the Mozilla Public License Version
// 1.1 (the "License"); you may not use this file except in compliance with
// the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// for the specific language governing rights and limitations under the
// License.
//
// The Original Code is Kyle Browning, released June 27, 2010.
//
// The Initial Developer of the Original Code is
// Kyle Browning
// Portions created by the Initial Developer are Copyright (C) 2010
// the Initial Developer. All Rights Reserved.
//
// Contributor(s):
//
// Alternatively, the contents of this file may be used under the terms of
// the GNU General Public License Version 2 or later (the "GPL"), in which
// case the provisions of the GPL are applicable instead of those above. If
// you wish to allow use of your version of this file only under the terms of
// the GPL and not to allow others to use your version of this file under the
// MPL, indicate your decision by deleting the provisions above and replacing
// them with the notice and other provisions required by the GPL. If you do
// not delete the provisions above, a recipient may use your version of this
// file under either the MPL or the GPL.
//
// ***** END LICENSE BLOCK *****

#import "DIOSUser.h"
#import "DIOSSession.h"
#import "DIOSSystem.h"
#import <CommonCrypto/CommonCrypto.h>
#import "Utilities.h"
#import "NSString+URLEncode.h"

@implementation DIOSUser

#pragma mark UserGets
+ (void)userGet:(NSDictionary *)user
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/%@", kDiosEndpoint, kDiosBaseUser, [user objectForKey:@"uid"]];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"GET"
                                                      params:user
                                                     success:success
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] getPath:path
                                parameters:user
                                   success:success
                                   failure:failure];
   }
}


#pragma mark userSaves
+ (void)userSave:(NSDictionary *)user
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@", kDiosEndpoint, kDiosBaseUser];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"POST"
                                                      params:user
                                                     success:success
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] postPath:path
                                 parameters:user
                                    success:success
                                    failure:failure];
   }
}

#pragma mark userRegister
+ (void)userRegister:(NSDictionary *)user
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/register", kDiosEndpoint, kDiosBaseUser];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"POST"
                                                      params:user
                                                     success:^(AFHTTPRequestOperation *op, id response) {
                                                        
                                                        DIOSIsUserLoggedIn = YES;
                                                        
                                                        NSDictionary* responseDict = response;
                                                        
                                                        DIOSLoggedInUserName = [user objectForKey:@"name"];
                                                        DIOSLoggedInUserId = [responseDict objectForKey:@"uid"];
                                                        
                                                        success(op, response);
                                                     }
       
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] postPath:path
                                 parameters:user
                                    success:^(AFHTTPRequestOperation *op, id response) {
                                       
                                       DIOSIsUserLoggedIn = YES;
                                       
                                       NSDictionary* responseDict = response;
                                       
                                       DIOSLoggedInUserName = [user objectForKey:@"name"];
                                       DIOSLoggedInUserId = [responseDict objectForKey:@"uid"];
                                       
                                       success(op, response);
                                    }
       
                                    failure:failure];
   }
}

#pragma mark userUpdate
+ (void)userUpdate:(NSDictionary *)user
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/%@", kDiosEndpoint, kDiosBaseUser, [user objectForKey:@"uid"]];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"PUT"
                                                      params:user
                                                     success:^(AFHTTPRequestOperation *op, id response) {
                                                        
                                                        DIOSIsUserLoggedIn = YES;
                                                        
                                                        NSDictionary* userDictionary = response;
                                                        DIOSLoggedInUserName = [userDictionary objectForKey:@"name"];
                                                        DIOSLoggedInUserId = [userDictionary objectForKey:@"uid"];
                                                        DIOSLoggedInUserUniqueId = [userDictionary objectForKey:@"uuid"];
                                                        
                                                        success(op, response);
                                                     }
       
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] putPath:path
                                parameters:user
                                   success:^(AFHTTPRequestOperation *op, id response) {
                                      
                                      DIOSIsUserLoggedIn = YES;
                                      
                                      NSDictionary* userDictionary = response;
                                      DIOSLoggedInUserName = [userDictionary objectForKey:@"name"];
                                      DIOSLoggedInUserId = [userDictionary objectForKey:@"uid"];
                                      DIOSLoggedInUserUniqueId = [userDictionary objectForKey:@"uuid"];
                                      
                                      success(op, response);
                                   }
       
                                   failure:failure];
   }
}

#pragma mark UserDelete
+ (void)userDelete:(NSDictionary *)user
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSNumber* uid = [user objectForKey:@"uid"];
   if(!uid || [uid isEqualToNumber: [NSNumber numberWithInt:0]] || [uid isEqualToNumber: [NSNumber numberWithInt:1]])
      [NSException raise:@"Invalid value for user Id" format:@"You cannot delete user wit id: %d", [uid intValue]];
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/%@", kDiosEndpoint, kDiosBaseUser, [user objectForKey:@"uid"]];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"DELETE"
                                                      params:user
                                                     success:success
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] deletePath:path
                                   parameters:user
                                      success:success
                                      failure:failure];
   }
}


#pragma mark userIndex
//Simpler method if you didnt want to build the params :)
+ (void)userIndexWithPage:(NSString *)page
                   fields:(NSString *)fields
               parameters:(NSArray *)parameteres
                 pageSize:(NSString *)pageSize
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure; {
   NSMutableDictionary *userIndexDict = [NSMutableDictionary new];
   [userIndexDict setValue:page forKey:@"page"];
   [userIndexDict setValue:fields forKey:@"fields"];
   [userIndexDict setValue:parameteres forKey:@"parameters"];
   [userIndexDict setValue:pageSize forKey:@"pagesize"];
   [self userIndex:userIndexDict success:success failure:failure];
}

+ (void)userIndex:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@", kDiosEndpoint, kDiosBaseUser];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"GET"
                                                      params:params
                                                     success:success
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] getPath:path
                                parameters:params
                                   success:success
                                   failure:failure];
   }
}

#pragma mark userLogin
+ (void)userLoginWithUsername:(NSString *)username andPassword:(NSString *)password
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:username, password, nil] forKeys:[NSArray arrayWithObjects:@"username", @"password", nil]];
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/login", kDiosEndpoint, kDiosBaseUser];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"POST"
                                                      params:params
                                                     success:^(AFHTTPRequestOperation *op, id response) {
                                                        
                                                        NSDictionary* responseDict = response;
                                                        DIOSIsUserLoggedIn = YES;
                                                        
                                                        NSDictionary* userDictionary = [responseDict objectForKey:@"user"];
                                                        DIOSLoggedInUserName = [userDictionary objectForKey:@"name"];
                                                        DIOSLoggedInUserId = [userDictionary objectForKey:@"uid"];
                                                        DIOSLoggedInUserUniqueId = [userDictionary objectForKey:@"uuid"];
                                                        
                                                        success(op, response);
                                                     }
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] postPath:path
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *op, id response) {
                                       
                                       NSDictionary* responseDict = response;
                                       DIOSIsUserLoggedIn = YES;
                                       
                                       NSDictionary* userDictionary = [responseDict objectForKey:@"user"];
                                       DIOSLoggedInUserName = [userDictionary objectForKey:@"name"];
                                       DIOSLoggedInUserId = [userDictionary objectForKey:@"uid"];
                                       DIOSLoggedInUserUniqueId = [userDictionary objectForKey:@"uuid"];
                                       
                                       success(op, response);
                                    }
                                    failure:failure];
   }
}
+ (void)userLogin:(NSDictionary *)user
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   [self userLoginWithUsername:[user objectForKey:@"name"]
                   andPassword:[user objectForKey:@"pass"]
                       success:success
                       failure:failure];
}

+ (void)userMakeSureUserIsLoggedInWithUsername:(NSString *)username
                                   andPassword:(NSString *)password
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   [DIOSSystem
    systemConnectwithSuccess:^(AFHTTPRequestOperation *op, id response) {
       
       NSDictionary* responseDict = response;
       
       if([[[responseDict objectForKey:@"user"]valueForKey:@"uid"]integerValue] == anonymous_user) {
          [DIOSUser userLoginWithUsername:username andPassword:password success:success failure:failure];
       }
       else if(![[[responseDict objectForKey:@"user"]valueForKey:@"name"] isEqualToString:username]){
          
          [DIOSUser
           userLogoutWithSuccessBlock:^(AFHTTPRequestOperation *op, id response) {
              [self userMakeSureUserIsLoggedInWithUsername:username andPassword:password success:success failure:failure];
           }
           failure:failure];
       }
       else {
          success(op, response);
       }
    }
    failure:failure];
}

#pragma mark userLogout
+ (void)userLogoutWithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   NSString *path = [NSString stringWithFormat:@"%@/%@/logout", kDiosEndpoint, kDiosBaseUser];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"POST"
                                                      params:nil
                                                     success:^(AFHTTPRequestOperation *op, id response) {
                                                        
                                                        DIOSIsUserLoggedIn = NO;
                                                        DIOSLoggedInUserName = nil;
                                                        DIOSLoggedInUserId = nil;
                                                        DIOSLoggedInUserUniqueId = nil;
                                                        
                                                        success(op, response);
                                                     }
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] postPath:path
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *op, id response) {
                                       
                                       DIOSIsUserLoggedIn = NO;
                                       DIOSLoggedInUserName = nil;
                                       DIOSLoggedInUserId = nil;
                                       DIOSLoggedInUserUniqueId = nil;
                                       
                                       success(op, response);
                                    }
       
                                    failure:failure];
   }
}

+ (void)userMakeSureUserIsLoggedOutWithSucess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
   
   
   [DIOSSystem
    systemConnectwithSuccess:^(AFHTTPRequestOperation *op, id response) {
       
       NSDictionary* responseDict = response;
       
       if([[[responseDict objectForKey:@"user"]valueForKey:@"uid"]integerValue] != anonymous_user)
          [DIOSUser userLogoutWithSuccessBlock:success failure:failure];
       else
          success(op, response);
    }
    failure:failure];
}

+ (void)userSendPasswordRecoveryEmailWithEmailAddress: (NSString*) email
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
   NSString *path = [NSString stringWithFormat:@"%@/resetpassword/%@", kDiosEndpoint, email];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"POST"
                                                      params:nil
                                                     success:success
                                                     failure:failure];
   }
   else {
      [[DIOSSession sharedSession] postPath:path
                                 parameters:nil
                                    success:success
                                    failure:failure];
   }
   
   
}

+ (void)userGetCurrentUserName:(NSString**) userName
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
   
   [DIOSSystem
    systemConnectwithSuccess:^(AFHTTPRequestOperation *op, id response) {
       
       NSDictionary* responseDict = response;
       if(userName != NULL) {
          
          if([[[responseDict objectForKey:@"user"]valueForKey:@"uid"]integerValue] == anonymous_user)
             *userName = anonymous_user_name;
       }
       else {
          
          *userName = [[responseDict objectForKey:@"user"]stringForKey:@"name"];
       }
       
       success(op, response);
    }
    failure:failure];
}

#pragma mark username validation
+ (BOOL)userValidateUserName:(NSString*)name error:(NSError**)error
{
   NSMutableDictionary* details = [[NSMutableDictionary alloc]init];
   
   if(name == nil) {
      
      [details setValue:@"You must enter a username." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameNil" forKey:@"ErrorKind"];
   }
   
   if([name hasPrefix:@" "]) {
      
      [details setValue:@"The username cannot begin with a space." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameHasWhitespacePrefix" forKey:@"ErrorKind"];
   }
   
   if([name hasSuffix:@" "]) {
      
      [details setValue:@"The username cannot end with a space." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameHasWhitespaceSuffix" forKey:@"ErrorKind"];
   }
   
   if([name rangeOfString:@"  "].location != NSNotFound) {
      
      [details setValue:@"The username cannot contain multiple spaces in a row." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameHasMultipleSpaces" forKey:@"ErrorKind"];
   }
   
   NSString *stricterFilterString = @"[A-Z0-9a-z ]*";
   NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
   if(![stringTest evaluateWithObject:name]) {
      
      [details setValue:@"The username can only conatain lower- and upper case characters, numbers and spaces." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameContainsIlleagalCharacters" forKey:@"ErrorKind"];
   }
   
   if(name.length > USERNAME_MAX_LENGTH) {
      
      [details setValue: [NSString stringWithFormat:@"The username %@ is too long: it must be %d characters or less.", name, USERNAME_MAX_LENGTH]  forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"UserNameIsTooLong" forKey:@"ErrorKind"];
   }
   
   if([details objectForKey:@"NSLocalizedRecoverySuggestion"]) {
      
      [details setValue:@"Invalid value for username" forKey:NSLocalizedDescriptionKey];
      
      if (error != NULL)
         *error = [NSError errorWithDomain:@"username" code:400 userInfo:details];
      
      return NO;
   }
   
   return YES;
}

#pragma mark user email validation
+ (BOOL)userValidateUserEmail:(NSString*)email error:(NSError**)error
{
   NSMutableDictionary* details = [[NSMutableDictionary alloc]init];
   
   if(email == nil) {
      
      [details setValue:@"You must enter an e-mail address." forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"EmailNil" forKey:@"ErrorKind"];
   }
   
   NSString *emailRegex =
   @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
   @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
   @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
   @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
   @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
   @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
   @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
   NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
   
   if(![emailTest evaluateWithObject:email]) {
      
      [details setValue:[NSString stringWithFormat:@"The e-mail address %@ is not valid.", email] forKey:@"NSLocalizedRecoverySuggestion"];
      [details setValue:@"EmailInvalid" forKey:@"ErrorKind"];
   }
   
   if([details objectForKey:@"NSLocalizedRecoverySuggestion"]) {
      
      [details setValue:@"Invalid value for email" forKey:NSLocalizedDescriptionKey];
      
      if (error != NULL)
         *error = [NSError errorWithDomain:@"email" code:400 userInfo:details];
      
      return NO;
   }
   
   return YES;
}

+ (void)userSendForgotPasswordEmailWithAddress:(NSDictionary *)params
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
   
   //Create name
   NSString *email = [params objectForKey:@"mail"];
   NSString *name =  [NSString stringWithFormat:@"%@%@",@"orcoffee_lostpassword::", email];
   
   //Create token:
   //Part 1: generate data
   NSString *salt = @"Wz2PeDuAVODC78N6xLhqONizPixfadk9G-MfvpMz98QzmkkzSLehqrTlN3quB-DkICBo9AF3ZYp2E6qLGnQPpE";
   
   //Part 2: hash_hmac data and key using SHA256
   const char *cData = [name cStringUsingEncoding:NSUTF8StringEncoding];
   const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
   
   
   unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
   
   CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
   
   NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                         length:sizeof(cHMAC)];
   
   //Part 3: Encode hmac with base64
   NSString *token = [HMAC base64Encoding];
   
   //Part 4: Replace characters
   token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
   token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
   token = [token stringByReplacingOccurrencesOfString:@"=" withString:@""];
   
   //Part 5: UrlEncode token
   token = [token urlencode];
   
   NSString *newEmail = [email stringByReplacingOccurrencesOfString:@"." withString:@"!"];
   
   NSString *path = [NSString stringWithFormat:@"%@/lostpassword/%@?token=%@", kDiosEndpoint, newEmail, token];
   
   if ([[DIOSSession sharedSession] signRequests]) {
      
      [[DIOSSession sharedSession] sendSignedRequestWithPath:path
                                                      method:@"PUT"
                                                      params:params
                                                     success:success
                                                     failure:failure];
   }
   else {
      
      [[DIOSSession sharedSession] putPath:path
                                parameters:params
                                   success:success
                                   failure:failure];
   }
}

@end