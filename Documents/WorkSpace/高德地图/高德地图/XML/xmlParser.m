//
//  xmlParser.m
//  xmlAnalysis
//
//  Created by MAC on 15/1/9.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import "xmlParser.h"

@implementation xmlParser

//开始解析
- (void) startAnalysis:(NSString *)filepath{
    _pos = [NSMutableArray new];
    
    TBXML* tbxml = [[TBXML alloc] initWithXMLFile:filepath error:nil];
    //TBXML* tbxml = [[TBXML alloc] initWithXMLString:filepath error:nil];
    TBXMLElement * root = tbxml.rootXMLElement;
    
    if (root) {
        //TBXMLElement * posElement = [TBXML childElementNamed:@"pos" parentElement:root];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:root];
        while (itemElement != nil) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            
            //获得属性值
            NSString *_time = [TBXML valueOfAttributeNamed:@"time" forElement:itemElement error:nil];
            [dict setValue:_time forKey:@"time"];
            
            NSString *_no = [TBXML valueOfAttributeNamed:@"no" forElement:itemElement error:nil];
            [dict setValue:_no forKey:@"no"];
            
            NSString *_x = [TBXML valueOfAttributeNamed:@"x" forElement:itemElement error:nil];
            [dict setValue:_x forKey:@"x"];
            
            NSString *_y = [TBXML valueOfAttributeNamed:@"y" forElement:itemElement error:nil];
            [dict setValue:_y forKey:@"y"];
            
            NSString *_h = [TBXML valueOfAttributeNamed:@"h" forElement:itemElement error:nil];
            [dict setValue:_h forKey:@"h"];

            [_pos addObject:dict];
            itemElement = itemElement->nextSibling;
        }
        _num = [_pos count];
    }
}

- (void) startAnalysisMessageVerification:(NSString *)XmlString{
    _xmlDic = [NSMutableDictionary new];
    TBXML* tbxml = [[TBXML alloc] initWithXMLFile:XmlString error:nil];
    //TBXML* tbxml = [[TBXML alloc] initWithXMLString:XmlString error:nil];
    TBXMLElement * root = tbxml.rootXMLElement;
    if (root) {
        //获得属性值
        
        TBXMLElement *itemElement = [TBXML childElementNamed:@"returnstatus" parentElement:root];
        char *returnstatus = itemElement->text;
        NSString *_returnstatus = [[NSString alloc] initWithUTF8String:returnstatus];
        [_xmlDic setValue:_returnstatus forKey:@"returnstatus"];
        
        itemElement = [TBXML childElementNamed:@"message" parentElement:root];
        char *message = itemElement->text;
        NSString *_message = [[NSString alloc] initWithUTF8String:message];
        [_xmlDic setValue:_message forKey:@"message"];
        
        itemElement = [TBXML childElementNamed:@"remainpoint" parentElement:root];
        char *remainpoint = itemElement->text;
        NSString *_remainpoint = [[NSString alloc] initWithUTF8String:remainpoint];
        [_xmlDic setValue:_remainpoint forKey:@"remainpoint"];
        
        itemElement = [TBXML childElementNamed:@"taskID" parentElement:root];
        char *taskID = itemElement->text;
        NSString *_taskID = [[NSString alloc] initWithUTF8String:taskID];
        [_xmlDic  setValue:_taskID forKey:@"taskID"];
        
        itemElement = [TBXML childElementNamed:@"successCounts" parentElement:root];
        char *successCounts = itemElement->text;
        
        NSString *_successCounts = [[NSString alloc] initWithUTF8String:successCounts];
        [_xmlDic  setValue:_successCounts forKey:@"successCounts"];
        
        
    }
}

@end
