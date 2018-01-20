//
//  UserMessageViewController.m
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 19/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import "UserMessageViewController.h"

@interface UserMessageViewController ()
{
    ZHCAudioMediaItem *currentAudioItem;
    NSTimer *timer;
    NSMutableArray *Chatmessages;
    ZHCMessage * messages;
    NSMutableArray *DictArray;

}
@end

@implementation UserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.messageTableView.estimatedRowHeight = 50.0;
    DictArray =[[NSMutableArray alloc]init];

    self.sendersDisplaynames =@"Vaibhav";
    NSString *uId =[ChatAppUserDefaults valueForKey:kUserId];
   
    self.senderids = [NSString stringWithFormat:@"%@",uId];
    self.userids = [NSString stringWithFormat:@"%@",uId];
    ZHCMessagesBubbleImageFactory *bubbleFactory = [[ZHCMessagesBubbleImageFactory alloc] init];
    
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:41/255.f green:152/255.f blue:255/255.f alpha:1.0]];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor zhc_messagesBubbleLightGrayColor]];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.presentBool) {
        // NSLog(@"%@",self);
       
        UILabel *lbl  =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [lbl setText:self.PartnerName];
        
        self.navigationController.navigationBar.barTintColor= [UIColor whiteColor];
        
        
        self.navigationController.navigationBar.translucent = NO;
        
        
        self.navigationController.navigationBar.tintColor =[UIColor blackColor];
       
        NSLog(@"sadf");
        UIButton *backBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0,0,32,32);
        [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = barBtn;
        //self.navigationItem.rightBarButtonItem =
        self.navigationItem.titleView = lbl;
        
    }
    [self ToFetchChatListfromAPI];
}
#pragma mark - Close btn Method
-(void)closePressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    ZHCWeakSelf;
    if (self.automaticallyScrollsToMostRecentMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollToBottomAnimated:NO];
        });
    }
}
-(NSString *)senderDisplayName
{
    return self.sendersDisplaynames;
}


-(NSString *)senderId
{
    return self.senderids;
}
#pragma mark - Chat List API Method
-(void)ToFetchChatListfromAPI
{
    [ProgressHUD show:@"Fetching conversations..."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
//NSString *token =@"429ab23d-4f05-4b25-a5af-55309c9566ee";
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ChatAppUserDefaults valueForKey:kToken] forHTTPHeaderField:@"Authorization"];
    
    
    NSLog(@"%@",[ChatAppUserDefaults valueForKey:kToken]);
    NSLog(@"%@%@%@",BASE_URL,GET_MSG_BY_USER,self.partnerId);
    [manager GET:[NSString stringWithFormat:@"%@%@%@",BASE_URL,GET_MSG_BY_USER,self.partnerId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id json = responseObject;
        
        
        /*  {
         "id": 2162,
         "message": "hi",
         "fromUserId": 4,
         "toUserId": 1,
         "createdDateTime": "2017-08-01T18:05:11.8313665"
         },*/
        Chatmessages = [[NSMutableArray alloc]init];

        NSMutableArray *tmpArr = json;

        DictArray = tmpArr ;

        for (NSDictionary *d in tmpArr) {
            
        
            
            NSString *uId = [NSString stringWithFormat:@"%@",[d valueForKey:@"fromUserId"]];
            NSLog(@"%@",self.userids);
            NSString *dateStr=[d valueForKey:@"createdDateTime"];
            //is your str
            
            NSArray *items = [dateStr componentsSeparatedByString:@"T"];   //take the one array for split the string
            
            NSString *convertedDateStr =[items objectAtIndex:0];
             NSString *convertedTimeStr =[items objectAtIndex:1];//shows Descri
            NSString *finalStr  =[NSString stringWithFormat:@"%@ %@",convertedDateStr,convertedTimeStr];
            
            if ([uId intValue]  == [self.userids intValue]) {
                
                [self DisplayMessageWithId:[NSString stringWithFormat:@"%@",[d valueForKey:@"fromUserId"]] Name:@"" txtMsg:[d valueForKey:@"message"] MsgDate:finalStr];
            }
            else
            {
                [self DisplayMessageWithId:[NSString stringWithFormat:@"%@",[d valueForKey:@"fromUserId"]] Name:@"" txtMsg:[d valueForKey:@"message"] MsgDate:finalStr];
                
                
                
                
            }
            
            
        }

        
        [self.messageTableView reloadData];
        if (DictArray.count == 0)
        {
            [self IntimateUserWithAlertWithPartner:self.PartnerName];
        }
        // self.navigationItem.titleView = lbl;
        
        ZHCWeakSelf;
        if (self.automaticallyScrollsToMostRecentMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf scrollToBottomAnimated:NO];
            });
        }
        
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:error.localizedDescription Interaction:NO];
        
    }];
}

-(void)IntimateUserWithAlertWithPartner:(NSString*)pname
{
    NSString *s = [NSString stringWithFormat:@"You've not started conversation yet! Click \"Send\" button to start conversation with %@",pname];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information!" message:s preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"SEND" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             //BUTTON OK CLICK EVENT
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alert animated:YES completion:nil];

    });
}
#pragma mark - Display message method
-(void)DisplayMessageWithId:(NSString*)ids Name:(NSString*)name txtMsg:(NSString*)txtmessage MsgDate:(NSString*)msgDate
{
  //2017-08-01
    //18:05:11.8313665
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    //8313665
                              //2017-08-01 18:05:11.8313665
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSS"];
    
    dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
//    NSString *localDateString = [dateFormat stringFromDate:dte];
//    NSLog(@"date = %@", localDateString);
    dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *dte = [dateFormat dateFromString:msgDate];
    NSLog(@"Date: %@", dte);
    
    ZHCMessage *msg =[[ZHCMessage alloc]initWithSenderId:ids senderDisplayName:name date:dte text:txtmessage];
    
   
    
    [Chatmessages addObject:msg];
    
    
    
    
    
}
-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
- (id<ZHCMessageData>)tableView:(ZHCMessagesTableView*)tableView messageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [Chatmessages objectAtIndex:indexPath.row];
}
- (nullable id<ZHCMessageBubbleImageDataSource>)tableView:(ZHCMessagesTableView *)tableView messageBubbleImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your TableView view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    ZHCMessage *message = [Chatmessages objectAtIndex:indexPath.row];
    if (message.isMediaMessage) {
        NSLog(@"is mediaMessage");
    }
    if ([message.senderId isEqualToString:self.userids]) {
        return self.outgoingBubbleImageData;
    }
    
    
    return self.incomingBubbleImageData;
    
    
}
-(void)tableView:(ZHCMessagesTableView *)tableView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [Chatmessages removeObjectAtIndex:indexPath.row];
}
- (nullable id<ZHCMessageAvatarImageDataSource>)tableView:(ZHCMessagesTableView *)tableView avatarImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    
    return nil;
}
-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.row %3 == 0) {
        ZHCMessage *message = [Chatmessages objectAtIndex:indexPath.row];
        return [[ZHCMessagesTimestampFormatter sharedFormatter]attributedTimestampForDate:message.date];
    }
    return nil;
}
-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCMessage *message = [Chatmessages objectAtIndex:indexPath.row];
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.userids]) {
        return nil;
    }
    
    if ((indexPath.row - 1) > 0) {
        ZHCMessage *preMessage = [Chatmessages objectAtIndex:(indexPath.row - 1)];
        if ([preMessage.senderId isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}


- (NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - Adjusting cell label heights
-(CGFloat)tableView:(ZHCMessagesTableView *)tableView heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    CGFloat labelHeight = 0.0f;
    if (indexPath.row % 3 == 0) {
        labelHeight = kZHCMessagesTableViewCellLabelHeightDefault;
    }
    return labelHeight;
    
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    CGFloat labelHeight = kZHCMessagesTableViewCellLabelHeightDefault;
    ZHCMessage *currentMessage = [Chatmessages objectAtIndex:indexPath.row];
    if ([[currentMessage senderId] isEqualToString:self.userids]) {
        labelHeight = 0.0f;
    }
    
    if (indexPath.row - 1 > 0) {
        ZHCMessage *previousMessage = [Chatmessages objectAtIndex:indexPath.row - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            labelHeight = 0.0f;
        }
    }
    
    return labelHeight;
    
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSAttributedString *string = [self tableView:tableView attributedTextForCellBottomLabelAtIndexPath:indexPath];
    if (string) {
        return kZHCMessagesTableViewCellSpaceDefault;
    }else{
        return 0.0;
    }
    
}

#pragma mark - ZHCMessagesTableViewDelegate
-(void)tableView:(ZHCMessagesTableView *)tableView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didTapAvatarImageView:avatarImageView atIndexPath:indexPath];
}


-(void)tableView:(ZHCMessagesTableView *)tableView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didTapMessageBubbleAtIndexPath:indexPath];
    // Do something
    
    ZHCMessage *message = [Chatmessages objectAtIndex:indexPath.row];
    if (message.isMediaMessage) {
        if ([message.media isKindOfClass:[ZHCPhotoMediaItem class]]) {
            //            ZHCPhotoMediaItem *photoMedia = (ZHCPhotoMediaItem *)message.media;
            //            UIImage *img = photoMedia.image;
            NSLog(@"Photo");
        }else if ([message.media isKindOfClass:[ZHCVideoMediaItem class]]){
            //            ZHCVideoMediaItem *videoMedia = (ZHCVideoMediaItem *)message.media;
            //            NSURL *videoUrl = videoMedia.fileURL;
            NSLog(@"Video");
        }
    }
}
#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Chatmessages.count;
}

-(UITableViewCell *)tableView:(ZHCMessagesTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCMessagesTableViewCell *cell = (ZHCMessagesTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Configure Cell Data
- (void)configureCell:(ZHCMessagesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ZHCMessage *message = [Chatmessages objectAtIndex:indexPath.row];
    
    if (!message.isMediaMessage) {
        if ([message.senderId isEqualToString:self.userids]) {
            cell.textView.textColor = [UIColor darkGrayColor];
            
        }else{
            cell.textView.textColor = [UIColor whiteColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
}
#pragma mark - Messages view controller

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<ZHCMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    ZHCMessage *message = [[ZHCMessage alloc] initWithSenderId:self.userids
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    [self ToSendANewMsgAPI:message.text withToUserId:self.partnerId];
    
    [self finishSendingMessageAnimated:YES];
    
}

#pragma mark - ZHCMessagesInputToolbarDelegate
-(void)messagesInputToolbar:(ZHCMessagesInputToolbar *)toolbar sendVoice:(NSString *)voiceFilePath seconds:(NSTimeInterval)senconds
{
    NSData * audioData = [NSData dataWithContentsOfFile:voiceFilePath];
    ZHCAudioMediaItem *audioItem = [[ZHCAudioMediaItem alloc] initWithData:audioData];
    audioItem.delegate = self;
    ZHCMessage *audioMessage = [ZHCMessage messageWithSenderId:self.senderId
                                                   displayName:self.senderDisplayName
                                                         media:audioItem];
    
    [Chatmessages addObject:audioMessage];
    
    [self finishSendingMessageAnimated:YES];
 
}



#pragma mark - ZHCMessagesMoreViewDelegate

-(void)messagesMoreView:(ZHCMessagesMoreView *)moreView selectedMoreViewItemWithIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:{//Camera
            //  [self.demoData addVideoMediaMessage];
            [self.messageTableView reloadData];
            [self finishSendingMessage];
        }
            break;
            
        case 1:{//Photos
            // [self.demoData addPhotoMediaMessage];
            [self.messageTableView reloadData];
            [self finishSendingMessage];
        }
            break;
            
        case 2:{
            
        }
        break;
            
        default:
            break;
    }
}

#pragma mark - ZHAudioMediaItemDelegate
- (void)audioMediaItem:(ZHCAudioMediaItem *)audioMediaItem
didChangeAudioCategory:(NSString *)category
               options:(AVAudioSessionCategoryOptions)options
                 error:(nullable NSError *)error{
    if (!error) {
        if (currentAudioItem && ![audioMediaItem isEqual:currentAudioItem]) {
            [currentAudioItem stopPlay];
        }
        currentAudioItem = audioMediaItem;
    }else{
        NSLog(@"Play Audio error:%@",error.localizedDescription);
    }
}


#pragma mark - ZHCMessagesMoreViewDataSource
-(NSArray *)messagesMoreViewTitles:(ZHCMessagesMoreView *)moreView
{
    return @[@"Camera",@"Photos",@"Location"];
}

-(NSArray *)messagesMoreViewImgNames:(ZHCMessagesMoreView *)moreView
{
    return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location"];
}

#pragma mark - To send a New message

-(void)ToSendANewMsgAPI:(NSString*)txtMsg withToUserId:(NSString*)touserId
{
    
    [ProgressHUD show];

    NSDictionary *parameters = @{@"Message": txtMsg, @"ToUserId":self.partnerId};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];


    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ChatAppUserDefaults valueForKey:kToken] forHTTPHeaderField:@"Authorization"];


   
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,SEND_MESSAGE] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ToFetchChatListfromAPI];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [ProgressHUD showError:error.localizedDescription Interaction:NO];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
