This project demonstrates 3 main concepts:

1. Use of a custom XIB for laying out a table cell
2. Use of a button on the cell to trigger an action in the tableview controller
3. Toggling the row heights from standard/base size to large enough to fit content

Some examples are from Apple sample code project "Accessory". Other code concepts from questions/answers on StackExchange, and http://mrmaksimize.com/ios/Custom-UITableViewCell-With-NIB/

1. To use a custom xib for a cell, the object in the xib must be a table cell, not a regular view item.
The Custom Class, class attribute must be set to the name of your controller code (the .h/.m files).
You can make properties and outlets on the xib for text labels and buttons.
I have a button set up but it is not connected to any method in the cell's class.
The XIB is set up using autolayout, which actually makes the code a lot simpler when the cell is expanded. For example, the text that is too long for the subtextView box can automatically report its desired content size. Then when the cell expands, there is no drawing code you have to write.


2. To toggle row heights, the button object on the cell is set up along with the other usual cell setup/drawing functions in tableView:cellForRowAtIndexPath.
The key here is that the button will have a function added via:addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside
This method calls self (which is the table view controller) to run a method that checks which cell was tapped. In other sample code, gesture recognizers are used to get the row via rowAtPoint (or something similar).
The meat of doing this is in this block of code that determines the row at the clicked button point:
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.mainTable];
	NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint: currentTouchPosition];
From there, the method can do whatever you need to with the information of the row clicked.

3. Expanding the row is done by 2 methods. First is a method inside of the cell class that will ask itself what the content size of the subtextView would be if all the text were to be displayed. It does not actually do any redrawing, it just returns a value.
The row heights are all stored in an array. This array is populated at init with default cell height values that are read from the base XIB cell at startup.
The function will ask a cell for its expanded height and replace the cell height in the array with that. In order to animate nicely, use tableView begin/endUpdates after that value is changed.

4. Bonus function: cells can be selected and deselected by tapping on anywhere in their view except of course the button. The selection is stored in a mutable dictionary. This also uses begin/endUpdates and unhighlights the row when pressed.


2013-10-25
Chris Paveglio