//
//  CustomCell.m
//  CustomTableCellTest
//
//  Created by Chris Paveglio on 10/19/13.
//  Copyright (c) 2013 Foil, Graphics, & More/Paveglio.com. All rights reserved.
//

#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomCell

@synthesize codeLabel;
@synthesize textLabel;
@synthesize subtextView;
@synthesize selectOptionSwitch;
@synthesize toggleButton;


-(float)expandedCellHeight
{
    //find the base cell height, subtract the current subtext height
    //to get the remainder
    float currentFrameHt = self.frame.size.height;
    float currentSTVHeight = self.subtextView.frame.size.height;
    float frameRemainder = currentFrameHt - currentSTVHeight;
    
    //this will be the height of only the full subtextView
    CGRect newTextViewFrame = self.subtextView.frame;
    newTextViewFrame.size.height = self.subtextView.contentSize.height;
    float stVHeight = self.subtextView.contentSize.height;
    
    //add subtextView box and remainder for entire cell height
    float combinedHeight = frameRemainder + stVHeight;
    
    return combinedHeight;
}

@end
