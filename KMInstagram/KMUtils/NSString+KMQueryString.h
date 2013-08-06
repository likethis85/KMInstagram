//
//  NSString+KMQueryString.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KMQueryString)
- (NSMutableDictionary *)dictionaryFromQueryComponents;
@end
