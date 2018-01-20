//
//  UserListViewController.h
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 19/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserMessageViewController.h"
@interface UserListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)NSString *userName;
@property(nonatomic)NSString *userId;
@property(nonatomic,retain)NSMutableArray *userListArray;
@property(nonatomic,weak)IBOutlet UITableView *userTblView;

@end
