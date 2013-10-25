//
//  CustomCell.h
//  CustomTableCellTest
//
//  Created by Chris Paveglio on 10/19/13.
//  Copyright (c) 2013 Foil, Graphics, & More/Paveglio.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextView *subtextView;
@property (weak, nonatomic) IBOutlet UISwitch *selectOptionSwitch;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

-(float)expandedCellHeight;

@end
