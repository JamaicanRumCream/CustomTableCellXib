//
//  MainViewController.h
//  CustomTableCellTest
//
//  Created by Chris Paveglio on 10/19/13.
//  Copyright (c) 2013 Foil, Graphics, & More/Paveglio.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL cavemanLogging;  //caveman debugging/logging
    
    NSArray *dummyDataDict;                 //fake table data to display
    NSMutableArray *cellHeightsMutable;     //all row heights
    NSMutableDictionary *selectedIndexes;   //rows that are selected (using dict not array, we can pass a raw NSIndexPath to it)
    NSNumber *baseCellHeight;               //this will be a constant value once set
}

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

-(BOOL)cellIsSelected:(NSIndexPath *)indexPath;
-(IBAction)toggleRowHeight:(id)sender;

@end
