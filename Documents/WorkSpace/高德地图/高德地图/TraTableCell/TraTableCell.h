//
//  TraTableCell.h
//  FounderSafeiOS
//
//  Created by MAC on 15/3/6.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol onClickCellButtonDelegate
@optional
- (void) onClickCellButton;
@end

@interface TraTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *LabelCell;
@property (strong, nonatomic) IBOutlet UILabel *LabelCell2;
@property (strong,nonatomic) id<onClickCellButtonDelegate> delegate;

- (IBAction)cellButton:(id)sender;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
