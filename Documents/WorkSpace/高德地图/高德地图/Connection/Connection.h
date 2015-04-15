//
//  DownloadData.h
//  Download
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#ifndef Download_DownloadData_h
#define Download_DownloadData_h

@protocol responseDelegate
@optional
- (void) onResponseResult:(NSString*)errorID Data:(NSData*) Data;
- (void) onResponseXml:(NSString*) XmlString;
@end

@interface Connection : NSObject

//@property(nonatomic,retain) id <errorID_Delegate> errorDelegate;

@property (strong,nonatomic) NSString* Error;
@property (strong,nonatomic) NSDictionary* listData;
@property (strong,nonatomic) NSMutableData *datas;
@property (strong,nonatomic) NSString *ContentType;
@property (strong,nonatomic) id<responseDelegate> delegate;
//异步GET方法发送请求
- (void) getRequest:(NSString *)strURL;

//异步POST方法发送请求
- (void) postRequest:(NSString *)strURL HTTPBody:(NSString *)httpBody delegate:(id<responseDelegate>)responseDelegate typeid:(int)TypeID;

//委托协议 NSURLConnectionDataDelegate 中的接收 response 方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

//委托协议 NSURLConnectionDataDelegate 中的接收 data 方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

//委托协议 NSURLConnectionDelegate 请求失败
- (void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error;

//委托协议 NSURLConnectionDataDelegate 请求完成
- (void) connectionDidFinishLoading: (NSURLConnection*) connection;


/*------------自定义方法-------------*/
//请求异常，将服务器返回的JSON数据解码
- (void)JSONDecode:(NSData *)data;

//请求成功，将服务器返回的数据写入文件
- (void)Write2File:(NSString*)file data:(NSData*)data;

@end

#endif
