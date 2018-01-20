//
//  UserListViewController.m
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 19/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Welcome,%@!",self.userName];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self ToGetAllUserListWithUserId:self.userId];

    
    
}
-(void)ToGetAllUserListWithUserId:(NSString*)uId
{
    self.userListArray =[[NSMutableArray alloc]init];
    
    [ProgressHUD show:@"Fetching userlist..." Interaction:NO];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
   // NSString *token =@"429ab23d-4f05-4b25-a5af-55309c9566ee";
    
    [manager.requestSerializer setValue:[ChatAppUserDefaults valueForKey:kToken] forHTTPHeaderField:@"Authorization"];
    

    NSLog(@"%@%@",BASE_URL,LIST_USERS);
    NSLog(@"%@",[ChatAppUserDefaults valueForKey:kToken]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,LIST_USERS] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id json = responseObject;
        
        
        
        NSMutableArray *arr = (NSMutableArray*)json;
        NSLog(@"%@",json);
        self.userListArray = arr;
        
        [self.userTblView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:error.localizedDescription Interaction:NO];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.userListArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *d =[self.userListArray objectAtIndex:indexPath.row];
    cell.textLabel.text =[d valueForKey:@"name"];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *d =[self.userListArray objectAtIndex:indexPath.row];
    
    NSString *ids=[NSString stringWithFormat:@"%@",[d valueForKey:@"id"]];

    if (![ids isEqualToString:@""]) {
        // valid id
        UserMessageViewController *messagesVC = [[UserMessageViewController alloc]init];
        messagesVC.presentBool = YES;
        messagesVC.PartnerName = [d valueForKey:@"name"];
        messagesVC.partnerId =[NSString stringWithFormat:@"%@",[d valueForKey:@"id"]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messagesVC];
        nav.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
