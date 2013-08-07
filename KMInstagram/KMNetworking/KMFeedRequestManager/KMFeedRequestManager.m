//
//  KMFeedRequestManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeedRequestManager.h"
#import "KMInstagramRequestClient.h"
#import "KMAPIController.h"
#import "JSONKit.h"
#import "KMFeed.h"
#import "KMPagination.h"


@interface KMBaseRequestManager()
@property (readwrite, nonatomic, strong) NSDate *lastUpdateDate;
@property (readwrite, nonatomic, strong) KMPagination *pagination;
@end

@interface KMFeedRequestManager()
@end

@implementation KMFeedRequestManager

- (void)getUserFeedWithCount:(NSInteger)count
                       minId:(NSString *)minId
                       maxId:(NSString *)maxId
                  completion:(CompletionBlock)completion
{
    self.loading = YES;
    
    NSMutableDictionary* parameters = [self baseParams];
    [parameters setObject:@(count) forKey:@"count"];
    if (minId) [parameters setObject:minId forKey:@"min_id"];
    if (maxId) [parameters setObject:maxId forKey:@"max_id"];
    
    __weak KMFeedRequestManager *self_ = self;
    [[KMInstagramRequestClient sharedClient] getPath:@"users/self/feed"
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *opertaion, NSDictionary *response){
//                                                 NSLog(@"------ *************** *******************-----------------");
//                                                 NSLog(@"%@",[response JSONString]);
//                                                 NSLog(@"------ *************** *******************-----------------");
                                                 __block NSMutableArray *feedsArray = [NSMutableArray new];
                                                 __block KMPagination *paging = nil;
                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     
                                                     paging = [[KMPagination alloc] initWithDictionary:[response objectForKey:@"pagination"]];
                                                     NSArray *responseObjects = [response objectForKey:@"data"];
                                                     [responseObjects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop){
                                                         KMFeed *feed = [[KMFeed alloc] initWithDictionary:object];
                                                         [feedsArray addObject:feed];
                                                     }];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self_.pagination = paging;
                                                         self_.loading = NO;
                                                         self_.lastUpdateDate = [NSDate date];
                                                         if (completion) {
                                                             completion([NSArray arrayWithArray:feedsArray], nil);
                                                         }
                                                     });
                                                 });
                                             }
                                             failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                 NSLog(@"error.description = %@",error.description);
                                                 self_.loading = NO;
                                                 if (completion) {
                                                     completion(nil, error);
                                                 }
                                             }];
}
@end
