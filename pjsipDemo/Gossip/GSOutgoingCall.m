//
//  GSOutgoingCall.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/12/12.
//

#import "GSOutgoingCall.h"
#import "GSCall+Private.h"
#import "Gossip-PJSIP.h"
#import "Util.h"
#import "SipAccountManager.h"

@implementation GSOutgoingCall

@synthesize remoteUri = _remoteUri;

- (id)initWithRemoteUri:(NSString *)remoteUri fromAccount:(GSAccount *)account {
    if (self = [super initWithAccount:account]) {
        _remoteUri = [remoteUri copy];
    }
    return self;
}

- (void)dealloc {
    _remoteUri = nil;
}


- (BOOL)begin {
    if (![_remoteUri hasPrefix:@"sip:"])
        _remoteUri = [@"sip:" stringByAppendingString:_remoteUri];
    
    pj_str_t remoteUri = [GSPJUtil PJStringWithString:_remoteUri];
    
    pjsua_call_setting callSetting;
    pjsua_call_setting_default(&callSetting);
    callSetting.aud_cnt = 1;
    callSetting.vid_cnt = 0; // TODO: Video calling support?
    
    
    /* FZS add header */
    pjsua_msg_data msg_data;
    pjsip_generic_string_hdr warn;
    
    pjsua_msg_data_init(&msg_data);
    
    
    NSString *numberDisplay = [NSString stringWithFormat:@"%@<%@:%@>", self.localNumber,[SipAccountManager shareAccount].account, [SipAccountManager shareAccount].ipAddress];
    
    const char *numberDisplay_ch = [numberDisplay UTF8String];
    
    pj_str_t pj_rpid_name = { "Remote-Party-ID", strlen("Remote-Party-ID") };
    pj_str_t pj_rpid_value = {(char *) numberDisplay_ch, strlen(numberDisplay_ch) };
    
    pjsip_generic_string_hdr_init2(&warn, &pj_rpid_name, &pj_rpid_value);
    pj_list_push_back(&msg_data.hdr_list, &warn);
    
    pjsua_call_id callId;
    GSReturnNoIfFails(pjsua_call_make_call(self.account.accountId, &remoteUri, &callSetting, NULL, &msg_data, &callId));
    
    [self setCallId:callId];
    return YES;
}


- (BOOL)end {
    NSAssert(self.callId != PJSUA_INVALID_ID, @"Call has not begun yet.");    
    GSReturnNoIfFails(pjsua_call_hangup(self.callId, 0, NULL, NULL));
    
    [self setStatus:GSCallStatusDisconnected];
    [self setCallId:PJSUA_INVALID_ID];
    return YES;
}

@end
