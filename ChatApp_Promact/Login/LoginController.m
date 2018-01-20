//
//  LoginController.m
//  ChatApp_Promact
//
//  Created by Yuvraj limbani on 19/01/18.
//  Copyright © 2018 Yuvraj limbani. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.txtUserName.text =@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Login Method

-(IBAction)btnLoginClicked:(id)sender
{
    [self ToCallLoginApi];
}

-(void)ToCallLoginApi
{
    
    if ([self checkValidation]) {
        
        // if pass validation call api
        [ProgressHUD show:@"Logging in..."];
        NSDictionary *parameters = @{@"Name": self.txtUserName.text};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id json = responseObject;
            NSString *token =[ChatAppUserDefaults objectForKey:kToken];
            if (![token isEqualToString:@""]) {
                 [ChatAppUserDefaults ResetChatDefaults];
            }
            [ChatAppUserDefaults setValue:[json valueForKey:@"token"] forKey:kToken];
            [ChatAppUserDefaults setValue:[json valueForKey:@"name"] forKey:kUserName];
             [ChatAppUserDefaults setValue:[json valueForKey:@"id"] forKey:kUserId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [ProgressHUD dismiss];
                [self performSegueWithIdentifier:kGoToUserListIdentifier sender:self];
                
            });
            
            

          //  NSLog(@"%@",json);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ProgressHUD showError:error.localizedDescription Interaction:NO];
            
        }];
        
    }
}
-(BOOL)checkValidation
{
    if ([self.txtUserName.text isEqualToString:@""])
    {
        [ProgressHUD showError:@"user name should not be blank"];
        return FALSE;
    }
    
    else if ([self.txtUserName.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location!=NSNotFound)
    {
        [ProgressHUD showError:@"Usename should not contain space" ];
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  NO;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kGoToUserListIdentifier]) {
       
        UserListViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        
        [vc setUserName:[ChatAppUserDefaults valueForKey:kUserName]];
        [vc setUserId:[ChatAppUserDefaults valueForKey:kUserId]];
        
    }
}
@end
