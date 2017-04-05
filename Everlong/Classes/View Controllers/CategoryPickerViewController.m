//
//  CategoryPickerViewController.m
//  Everlong
//
//  Created by Brian Morton on 8/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CategoryPickerViewController.h"
#import "ProductsViewController.h"
#import "ECTag.h"
#import "AnalyticsHelper.h"

@implementation CategoryPickerViewController

@synthesize tags = _tags;
@synthesize loadingViewIsVisible;
@synthesize loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Categories"];
        self.loadingViewIsVisible = NO;
    }
    return self;
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.loadingViewIsVisible = YES;
    categoriesTableView.backgroundColor = [UIColor listViewBackgroundColor];
    [self loadObjectsFromDataStore];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/list-categories"];            
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self additionalViewWillAppearForTableView];
}

- (void)viewDidUnload {
    categoriesTableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadObjectsFromDataStore {
	NSFetchRequest *request = [ECTag fetchRequest];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	_tags = [ECTag objectsWithFetchRequest:request];
}

- (void)loadData {
    // Clean out the Tag entities in the Data Store
    _tags = nil;
    NSManagedObjectContext *myContext = [[[RKObjectManager sharedManager] objectStore] managedObjectContext];
    NSFetchRequest *request = [ECTag fetchRequest];
    [request setIncludesPropertyValues:NO];
    NSArray *tagArray = [ECTag objectsWithFetchRequest:request];
    for (NSManagedObject * tag in tagArray) {
        [myContext deleteObject:tag];
    }
    NSError *saveError = nil;
    [myContext save:&saveError];
    if (saveError) NSLog(@"xxxxxxxxx Error Saving: %@ xxxxxxxxx",saveError);
    
    // Then load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/tags" delegate:self];
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedTagsAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self loadObjectsFromDataStore];
	[categoriesTableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:[error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}


#pragma mark - UITableView methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ECTag *currentTag = [self.tags objectAtIndex:[indexPath row]];
    [cell.textLabel setText:currentTag.name];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tags count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductsViewController *productsViewController = [[ProductsViewController alloc] init];
    productsViewController.tag = [self.tags objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:productsViewController animated:YES];
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)additionalViewWillAppearForTableView {
    // Unselect the selected row if any
    NSIndexPath *selection = [categoriesTableView indexPathForSelectedRow];
    if (selection) {
        [categoriesTableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [categoriesTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [categoriesTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [categoriesTableView flashScrollIndicators];
}

@end
