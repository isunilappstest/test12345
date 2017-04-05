//
//  RegionPickerViewController.m
//  Everlong
//
//  Created by Brian Morton on 1/11/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "RegionPickerViewController.h"
#import "AnalyticsHelper.h"
#import "ECRegion.h"

@implementation RegionPickerViewController

@synthesize tableView = _tableView;
@synthesize regions = _regions;
@synthesize placementsViewController = _placementsViewController;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Select a region";
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)buildTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildTableView];
    [self loadObjectsFromDataStore];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/list-regions"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.frame;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableView methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RegionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ECRegion *currentRegion = [self.regions objectAtIndex:[indexPath row]];
    [cell.textLabel setText:currentRegion.name];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.regions count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ECRegion *currentRegion = [self.regions objectAtIndex:[indexPath row]];
    [ECRegion setCurrentRegion:currentRegion];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Data loading methods

- (void)loadObjectsFromDataStore {
	NSFetchRequest *request = [ECRegion fetchRequest];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	_regions = [ECRegion objectsWithFetchRequest:request];
    [self.tableView reloadData];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end
