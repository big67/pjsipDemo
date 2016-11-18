//
//  SipAccountManager.m
//  fzsdh
//
//  Created by a on 16/4/13.
//  Copyright © 2016年 fengbangshou. All rights reserved.
//

#import "SipAccountManager.h"

@implementation SipAccountManager

+(SipAccountManager *)shareAccount{
    static SipAccountManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        
        
    });
    return sharedAccountManagerInstance;
}

- (void)configAndStart{
    
    [_agent reset];
    
    GSAccountConfiguration *accountConfig = [GSAccountConfiguration defaultConfiguration];

    accountConfig.address = [NSString stringWithFormat:@"%@@@%@", self.account, self.ipAddress];;
    accountConfig.username = self.account;
    accountConfig.password = self.password;
    accountConfig.domain = self.ipAddress;
    accountConfig.authRealm = @"*";
    accountConfig.proxyServer = self.proxyServer;
    

// etc.
//    accountConfig.address = @"101@192.168.88.111";
//    accountConfig.username = @"101";
//    accountConfig.password = @"101";
//    accountConfig.domain = @"192.168.88.111";
//    accountConfig.authRealm = @"*";
//    accountConfig.proxyServer = @"192.168.88.111";
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = accountConfig;
    configuration.logLevel = 0;
    configuration.consoleLogLevel = 0;
    
    self.agent = [GSUserAgent sharedAgent];
    
    [self.agent configure:configuration];
    [self enableCodec];
    [self.agent start];
    
}


-(void)enableCodec
{
    NSArray *codeArr = [self.agent arrayOfAvailableCodecs];
    for(GSCodecInfo *codec in codeArr){
        NSLog(@"%@", codec.codecId);

        if(!([codec.codecId isEqualToString:@"GSM/8000/1"] || [codec.codecId isEqualToString:@"PCMU/8000/1"] || [codec.codecId isEqualToString:@"PCMA/8000/1"])){
            [codec disable];
        }
        if(!([codec.codecId isEqualToString:@"G729/8000/1"])){
            [codec disable];
        }
        
        
    }
}


#pragma mark - GSAccountDelegate

- (void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)call {
    // incomming call
    
    //    _incomingCall = call;
    //
    //    UIAlertView *alert = [[UIAlertView alloc] init];
    //    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    //    [alert setDelegate:self];
    //    [alert setTitle:@"Incoming call."];
    //    [alert addButtonWithTitle:@"Deny"];
    //    [alert addButtonWithTitle:@"Answer"];
    //    [alert setCancelButtonIndex:0];
    //    [alert show];
}


@end
