//
//  SipAccountManager.h
//  fzsdh
//
//  Created by a on 16/4/13.
//  Copyright © 2016年 fengbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gossip.h"

@interface SipAccountManager : NSObject<GSAccountDelegate>

@property(nonatomic, strong) GSUserAgent *agent;

@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *ipAddress;
@property(nonatomic, copy) NSString *proxyServer;

+(SipAccountManager *)shareAccount;

- (void)configAndStart;


@end
