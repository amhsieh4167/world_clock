//
//  MasterViewController.m
//  world_clock
//
//  Created by Alex Hsieh on 11/10/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "City.h"
#import "ClockCell.h"
#import "ClockView.h"

@interface MasterViewController ()
{
    NSTimer* appTimer;
    // declare currentTime here;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)updateTimer:(NSTimer*)timer;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
    [_fetchedResultsController release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;

    [self startClock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//         // Replace this implementation with code to handle the error appropriately.
//         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}

-(void)startClock
{
    appTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];

    [appTimer fire];
}

-(void)updateTimer:(NSTimer*)timer
{
    // what is happening in the memory here??
    // _currenTime is the iVAR;
    _currentTime = [NSDate date];
    [_currentTime retain];
    [self.tableView reloadData];
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ClockCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    City* city = (City*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.oCityLabel.text = city.name;
    
    NSTimeZone* timeZone = [[NSTimeZone alloc] initWithName:city.timeZone];
    
    //  set up the dateFormatter
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"hh:mm:ss a z"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString* localTimeInString;
    localTimeInString = [dateFormatter stringFromDate:_currentTime];
    cell.oLocalTimeLabel.text = localTimeInString;
    
    ClockView* clockView = [[ClockView alloc] initWithFrame: CGRectMake(0, 0, cell.oClockView.frame.size.width, cell.oClockView.frame.size.height)];
    [clockView setClockBackgroundImage:[UIImage imageNamed:@"clockFace"].CGImage];
    [clockView setHourHandImage:[UIImage imageNamed:@"hourHand.png"].CGImage];
    [clockView setMinHandImage:[UIImage imageNamed:@"minuteHand.png"].CGImage];
    [clockView setSecHandImage:[UIImage imageNamed:@"secondHand.png"].CGImage];
    
    
    NSDate *clockTime = [_currentTime dateByAddingTimeInterval:(60.0*60.0*[city.offset integerValue])];
    NSLog(@"current city is %@", city.name);
    NSLog(@"Current time is %@", _currentTime);
    NSLog(@"Time after offset is %@", clockTime);
    clockView.clockTime = clockTime;
    [clockView updateClock:appTimer];
    [cell.oClockView addSubview:clockView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//        [[segue destinationViewController] setDetailItem:object];
//    }
}


#pragma mark - Fetched results controller


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"offset" ascending:YES] autorelease];
    NSArray *sortDescriptors = @[sortDescriptor];
    //NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

// one time use only to set up the data. will set up adding additional city later
/*
 NSManagedObjectContext *context = self.managedObjectContext;
 City* newYork = (City*)[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
 newYork.name = @"New York";
 newYork.timeZone = @"America/New_York";
 newYork.offset = [NSNumber numberWithInt: -5];
 
 City* chicago = (City*)[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
 chicago.name = @"Chicago";
 chicago.timeZone = @"America/Chicago";
 chicago.offset = [NSNumber numberWithInt: -6];
 
 City* los_Angeles = (City*)[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
 los_Angeles.name = @"Los Angeles";
 los_Angeles.timeZone = @"America/Los_Angeles";
 los_Angeles.offset = [NSNumber numberWithInt: -8];
 
 City* denver = (City*)[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
 denver.name = @"Denver";
 denver.timeZone = @"America/Denver";
 denver.offset = [NSNumber numberWithInt: -7];
 
 NSError* error = nil;
 
 if (![context save:&error]) {
 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
 abort();
 }
 */




@end
