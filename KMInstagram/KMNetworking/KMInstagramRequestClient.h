//
//  KMInstagramRequestClient.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//


#import "AFHTTPClient.h"
@interface KMInstagramRequestClient : AFHTTPClient
+ (KMInstagramRequestClient *)sharedClient;
@end
