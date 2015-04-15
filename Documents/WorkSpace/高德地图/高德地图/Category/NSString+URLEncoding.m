//
//  NSString+URLEncoding.m
//  FounderSafeiOS
//
//  Created by MAC on 15/1/22.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)URLEncodedString
{
    NSString* result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                      (kCFAllocatorDefault,
                       (CFStringRef)self,
                       NULL,
                       CFSTR("+$,#[] "),
                       kCFStringEncodingUTF8));
    return result;
}

-(NSString *)URLDecodedString;
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                      (kCFAllocatorDefault,
                       (CFStringRef)self,
                       CFSTR(""),
                       kCFStringEncodingUTF8));
    return result;
}

@end