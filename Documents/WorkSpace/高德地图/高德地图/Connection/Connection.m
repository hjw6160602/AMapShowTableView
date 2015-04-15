//
//  DownloadData.m
//  Download
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NSString+URLEncoding.h"
#import "Connection.h"

@implementation Connection

- (void) getRequest:(NSString *)strURL{
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        _datas = [NSMutableData new];
        NSLog(@"异步请求成功");
    }
}

- (void) postRequest:(NSString *)strURL HTTPBody:(NSString *)httpBody delegate:(id<responseDelegate>)responseDelegate typeid:(int)TypeID {
    NSData *postData = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    //将httpBody转为流 NSInputStream
    NSInputStream *postDataStream;
    if(postData){
        postDataStream = [NSInputStream inputStreamWithData:postData];}
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];  //设置头文件类型
    
    //Anti-mage 判断httpBody的流是否为空
    if(postData)
    {
        // [request setHTTPBodyStream: postDataStream];  //向服务器发送流
        
        [request setHTTPBody: postData];  //设置向服务器发送的数据
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        _datas = [NSMutableData new];
        NSLog(@"异步请求成功");
    }
    
    _delegate = responseDelegate;
    
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"收到Response");
    //将NSURLResponse对象转换成NSHTTPURLResponse对象
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *responseHeaders = [httpResponse allHeaderFields];
    //NSLog(@"%@",responseHeaders);
    _ContentType = [responseHeaders valueForKey:@"Content-Type"];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
}


- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成...\n\n");
    NSString* ServerData= [[NSString alloc] initWithData:_datas encoding:NSUTF8StringEncoding];
    NSLog(@"服务器返回数据为：\n%@",ServerData);
    
    NSLog(@"数据获取成功！");
    NSLog(@"%@",_ContentType);
    
    if([_ContentType  isEqual: @"application/json;charset=UTF-8"])
        [self JSONDecode:_datas];
    else if([_ContentType  isEqual: @"text/html;charset=utf-8"])
        [self Write2File:@"/Users/mac/Desktop/error.html" data:_datas];
    else if([_ContentType  isEqual: @"application/zip;charset=UTF-8"])
        [_delegate onResponseResult:nil Data:_datas];
    else if([_ContentType  isEqual: @"text/xml; charset=utf-8"])
        [_delegate onResponseXml:ServerData];
}


-(void)JSONDecode:(NSData *)data{
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers
                                                   error:&error];
    if(!jsonObj || error){
        NSLog(@"JSON解码失败！");
    }
    
    self.listData = jsonObj;
    //类型转换
    id errorID = [self.listData valueForKey:@"error"];
    _Error = [NSString stringWithFormat:@"%@",errorID];
    NSString *message = [self.listData valueForKey:@"message"];
    NSMutableString* JSON=[[NSMutableString alloc] initWithString:@"\n"];
    //[JSON appendString:@"消息ID: "];
    //[JSON appendString:_Error];
    [JSON appendString:@"消息内容： "];
    if(message != nil){
        [JSON appendString:message];
    }
    /*
    if (![_Error isEqualToString:@"0"])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle: @"提示"
                                                              message: JSON
                                                             delegate: nil
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:nil];
        [myAlertView show];
    }*/
    [_delegate onResponseResult:_Error Data:data];
}

- (void)Write2File:(NSString*)file data:(NSData*)data{
    NSLog(@"开始写入文件！");
    NSFileManager *fm=[NSFileManager defaultManager];
    //NSString *file=@"/Users/mac/Desktop/Download.zip";
    NSData *filePath=[fm contentsAtPath:file];
    if(![fm fileExistsAtPath:file])
        [fm createFileAtPath:file contents:filePath attributes:nil];
    [data writeToFile:file atomically:YES];
}

- (int) Ping:(NSString *)strURL Time:(NSString *)time delegate:(id<responseDelegate>)responseDelegate {
    int timeSec= [time intValue];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];  //设置头文件类型
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection)
    {
        _datas = [NSMutableData new];
        NSLog(@"异步请求成功");
    }
    return timeSec;
}

@end