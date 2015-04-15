//
//  xmlParser.h
//  xmlAnalysis
//
//  Created by MAC on 15/1/9.
//  Copyright (c) 2015年 MAC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface xmlParser : NSObject

@property (nonatomic) NSInteger num;

//解析出的数据内部是字典类型
@property (strong,nonatomic) NSMutableArray *pos;
@property (strong,nonatomic) NSMutableDictionary *xmlDic;

//开始解析
- (void) startAnalysis:(NSString *)filepath;
- (void) startAnalysisMessageVerification:(NSString *)XmlString;
@end
