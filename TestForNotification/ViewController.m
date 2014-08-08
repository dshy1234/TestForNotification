//
//  ViewController.m
//  TestForNotification
//
//  Created by dshy1234 on 14-8-6.
//  Copyright (c) 2014年 redcdn. All rights reserved.
//

#import "ViewController.h"
#import "APService.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonFunc.h"
#import <CommonCrypto/CommonDigest.h>

#define _PushURL @"http://api.jpush.cn:8800/v2/push"
#define appkey @"1147820011f8791279a00a7a"
#define masterSecret @"f3105bae08bd366ac6f40258"


@interface ViewController ()
@property (assign, nonatomic) IBOutlet UITextField *textAdd;
@property (assign, nonatomic) IBOutlet UITextField *textSend;

- (IBAction)add:(id)sender;
- (IBAction)send:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender{
  [APService setTags:[NSSet setWithObjects:self.textAdd.text,nil] alias:@"别名" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}
//- (IBAction)send:(id)sender{
//  [self sendaaa];
//////  NSString *base64String = [CommonFunc base64StringFromText:[NSString stringWithFormat:@"%@:%@",appkey,masterSecret]];
////  
////  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_PushURL ]];
////  [request setTimeoutInterval:10.f];
////  [request setHTTPMethod:@"POST"];
////  
////  NSString *jsonString = [NSString stringWithFormat:@"{\"platform\": \"all\",\"audience\": {\"tag\": [\"\%@\"]},\"notification\": {\"ios\": {\"alert\": \"hello, JPush!\",\"sound\": \"soundA\"}},\"options\": {\"apns_production\": false}}",self.textSend.text];
////                          
////  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////  [request setValue:[NSString stringWithFormat:@"Basic %@",@"MTE0NzgyMDAxMWY4NzkxMjc5YTAwYTdhOiBmMzEwNWJhZTA4YmQzNjZhYzZmNDAyNTg="] forHTTPHeaderField:@"Authorization"];
////  
////  
////  [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
////  AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc]initWithRequest:request];
////  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
////   {
////     UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"发送成功" message:responseObject delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
////     [alertView show];
////   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//     UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"发送失败" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//     [alertView show];
////     NSLog(@"Failure: %@", error);
////   }];
////  [operation start];
//}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
  UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"注册成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
  [alertView show];
  NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (IBAction)send:(id)sender{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
  
  NSDictionary *parameters = @{@"sendno":[NSNumber numberWithInt:10],
                               @"app_key":@"1147820011f8791279a00a7a",
                               @"receiver_type":[NSNumber numberWithInt:2],
                               @"receiver_value":self.textSend.text,
                               @"verification_code":[self md5:[NSString stringWithFormat:@"%i%i%@%@",10,2,self.textSend.text,@"f3105bae08bd366ac6f40258"]],
                               @"msg_type":[NSNumber numberWithInt:1],
                               @"msg_content":@"{\"n_content\": \"收到电话\",\"n_extras\": {\"ios\": {\"sound\": \"ring.caf\"}}}",
                               };
  
  [manager POST:_PushURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
    
    NSLog(@"%@", responseObject);
    NSString *requestTmp = [NSString stringWithString:operation.responseString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    //系统自带JSON解析
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"resultDic:%@", resultDic);
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"发送成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];

    
  }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"发送失败" message:[NSString stringWithFormat:@"-----------错误信息：%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"-----------错误信息：%@", error);
  }];
}

- (NSString *)md5:(NSString *)str
{
  const char *cStr = [str UTF8String];
  unsigned char result[16];
  CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
  NSString *retString = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
  return retString;
}
@end
