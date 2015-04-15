//
//  TraTableCell.m
//  FounderSafeiOS
//
//  Created by MAC on 15/3/6.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import "TraTableCell.h"

@implementation TraTableCell

- (IBAction)cellButton:(id)sender {
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"TraTableCell";
    TraTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // 如果找不到就从xib中创建cell
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"TraTableCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end