//
//  MainViewController.m
//  CustomTableCellTest
//
//  Created by Chris Paveglio on 10/19/13.
//  Copyright (c) 2013 Foil, Graphics, & More/Paveglio.com. All rights reserved.
//

#import "MainViewController.h"
#import "CustomCell.h"


@implementation MainViewController

@synthesize mainTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //some sample data to display
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:@"A31", @"code", @"scrubbing bubbles", @"description", @"these are nice, Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit", @"subtext", nil];
        NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:@"B15", @"code", @"15lb dumbells", @"description", @"for weak arm people, Sed ut perspiciatis unde omnis iste natus error sit", @"subtext", nil];
        NSDictionary *d3 = [NSDictionary dictionaryWithObjectsAndKeys:@"C85", @"code", @"sofa sectional", @"description", @"slippery, Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit", @"subtext", nil];
        NSDictionary *d4 = [NSDictionary dictionaryWithObjectsAndKeys:@"D56", @"code", @"hybrid powertrain", @"description", @"good fuel mileage, Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.", @"subtext", nil];
        NSDictionary *d5 = [NSDictionary dictionaryWithObjectsAndKeys:@"E19", @"code", @"M4 Marching Band", @"description", @"amazing crazy good, Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi", @"subtext", nil];
        
        dummyDataDict = [NSArray arrayWithObjects:d1, d2, d3, d4, d5, nil];
        cellHeightsMutable = [NSMutableArray array];
        cavemanLogging = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndexes = [[NSMutableDictionary alloc] init];
    
    //create a cell prototype for the table from the nib, assign to table
    UINib *cellNib = [UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]];
    [mainTable registerNib:cellNib forCellReuseIdentifier:@"CustomCellReuseID"];
    
    //query object for view size
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    CGRect cellFrameSize = [(CustomCell *)[nibArray objectAtIndex:0] frame];

    //set ivar of standard cell height for later
    baseCellHeight = [NSNumber numberWithFloat:cellFrameSize.size.height];

    //create an array to hold the row heights, using default height to start
    for (int i = 0; i < [dummyDataDict count]; i++) {
        [cellHeightsMutable addObject:baseCellHeight];
    }
if (cavemanLogging) NSLog(@"cellHeightsMutable on startup: %@", cellHeightsMutable);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Cell Expansion


-(IBAction)toggleRowHeight:(id)sender
{
    // get cell index path from querying the tableview (ie superview), sender == cell
    NSIndexPath *index = [self.mainTable indexPathForCell:(UITableViewCell *)[sender superview]];
    
if (cavemanLogging) NSLog(@"toggleRowHeight row= %d", [index row]);
    
    CustomCell *cell = (CustomCell *)[self.mainTable cellForRowAtIndexPath:index];
    float newHeight = [cell expandedCellHeight];
    [cellHeightsMutable setObject:[NSNumber numberWithFloat:newHeight] atIndexedSubscript:[index row]];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	//the toggle button calls this method to toggle row height
    //get the touched/tapped button location and translate it to a row
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.mainTable];
    
	NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
        if ([cellHeightsMutable objectAtIndex:[indexPath row]] > baseCellHeight) {
            //the cell is already expanded, so toggle back to small size, use default value
            [cellHeightsMutable setObject:baseCellHeight atIndexedSubscript:[indexPath row]];
        } else {
    if (cavemanLogging) NSLog(@"checkButtonTapped row= %d", [indexPath row]);
        //ask the cell at row X to get its expanded size
        float expSize = [(CustomCell *)[self.mainTable cellForRowAtIndexPath:indexPath] expandedCellHeight];
    if (cavemanLogging) NSLog(@"checkButtonTapped expaned= %f", expSize);
        //put new size into row heights array
        [cellHeightsMutable setObject:[NSNumber numberWithFloat:expSize] atIndexedSubscript:[indexPath row]];
        }
	}
if (cavemanLogging) NSLog(@"cellHeightsMutable after button tapped= %@", cellHeightsMutable);
    
    //automagically expand/reload rows
    [mainTable beginUpdates];
    [mainTable endUpdates];
}


#pragma mark - Table Delegation


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //mostly standard cell creation method
    static NSString *CellIdentifier = @"CustomCellReuseID";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Configure the cell...
    cell.codeLabel.text = [[dummyDataDict objectAtIndex:[indexPath row]] objectForKey:@"code"];
    cell.textLabel.text = [[dummyDataDict objectAtIndex:[indexPath row]] objectForKey:@"description"];
    cell.subtextView.text = [[dummyDataDict objectAtIndex:[indexPath row]] objectForKey:@"subtext"];
    cell.selectOptionSwitch.on  = [[selectedIndexes objectForKey:indexPath] boolValue];
    //add the action to the button, can not set it up in IB
    [[cell toggleButton] addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //only 1 section
    return [dummyDataDict count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //since all of our row heights are in a big array, just find the number at row index
    return (CGFloat)[[cellHeightsMutable objectAtIndex:[indexPath row]] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Deselect cell so it's not permanently shaded a color
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    //Toggle 'selected' state
    BOOL isSelected = ![self cellIsSelected:indexPath];
    //Store cell 'selected' state keyed on indexPath
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [selectedIndexes setObject:selectedIndex forKey:indexPath];
    //update the switch display
    //this happens instantly, but if you replace with custom checkmark graphic it would appear like appropriate action
    [(CustomCell *)[mainTable cellForRowAtIndexPath:indexPath] selectOptionSwitch].on = isSelected;
    
    // This is where magic happens...
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
