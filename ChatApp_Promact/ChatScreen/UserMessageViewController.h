//
//  UserMessageViewController.h
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 19/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZHChat/ZHCMessages.h>
#import <AFNetworking.h>
#import <ProgressHUD/ProgressHUD.h>
#import "Global_Constant.h"
#import "ChatAppUserDefaults.h"
@interface UserMessageViewController : ZHCMessagesViewController<ZHCAudioMediaItemDelegate>
@property (assign, nonatomic) BOOL presentBool;
@property(nonatomic,retain)NSString *partnerId;
@property(nonatomic,strong)NSString *PartnerName;
@property(retain)NSString *senderids;
@property(retain)NSString *userids;

@property(retain)NSString *sendersDisplaynames;

@property (strong, nonatomic) ZHCMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) ZHCMessagesBubbleImage *incomingBubbleImageData;
@end
