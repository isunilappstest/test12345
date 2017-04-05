//
//  AttributesSelectionViewController.m
//  Everlong
//
//  Created by Jason Cox on 9/27/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//


//ERROR_LOG('ASDFASDFASDF',3, '/TMP/ERIC');
#import "AttributesSelectionViewController.h"
#import "CheckoutViewController.h"
#import "ECAttribute.h"
#import "ECAttributeOption.h"
#import "AnalyticsHelper.h"
@interface AttributesSelectionViewController ()
-(void)removeInterfaces;
-(void)setupAddressInterface;
-(void)setupSelectInterface;
-(void)setupInputInterface;
@end

@implementation AttributesSelectionViewController

@synthesize addressInterface = _addressInterface;
@synthesize inputInterface = _inputInterface;
@synthesize currentField = _currentField;

//Input textfields
@synthesize input = _input;

//Address TextFields
@synthesize name = _name;
@synthesize address1 = _address1;
@synthesize address2 = _address2;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;

@synthesize attributesTableView = _attributesTableView;
@synthesize attribute = _attribute;
@synthesize headerView = _headerView;

@synthesize inputNameLabel = _inputNameLabel;
@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;

@synthesize quantityToBuy = _quantityToBuy;

@synthesize addressDoneButton = _addressDoneButton;
@synthesize inputDoneButton = _inputDoneButton;

@synthesize accessoryView = _accessoryView;


#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Attributes"];
    
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-attributes"];            
    self.nameLabel.text = self.attribute.name;
    self.inputNameLabel.text = self.attribute.name;
    self.descriptionLabel.text = @"";
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    CGRect viewHeightModification = self.headerView.frame;
    viewHeightModification.size.height = self.nameLabel.frame.size.height + 10;
    //10 for padding
    self.headerView.frame = viewHeightModification;
     
    //Now figure out which type it is and handle it accordingly.
    
    if(self.attribute.attributeType == AttributeTypeInput){
        
        [self setupInputInterface];
        
    }else if(self.attribute.attributeType == AttributeTypeAddress){
        [self setupAddressInterface];
    }else if(self.attribute.attributeType == AttributeTypeSelect){
        [self setupSelectInterface];
    }else{
        NSLog(@"NOTHING TO SETUP!!!!");
    }
    

    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableView delegate and datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attribute.options.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.attribute.name;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"attributeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ECAttributeOption *option = [self.attribute.options objectAtIndex:indexPath.row];
    
    if([option.quantity intValue] == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@", option.option];        
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@ left)", option.option, option.quantity];
    }
    //cell.detailTextLabel.text = attribute.activeInventory.priceInDollars;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ECAttributeOption *option = [self.attribute.options objectAtIndex:indexPath.row];
    
    if([option.quantity intValue] > 0 && [self.quantityToBuy intValue] > [option.quantity intValue]){
        //WE HAVE A PROBLEM!!!!
        //Trying to buy more than we have.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You've chosen to buy more than we have!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    option.selectedValue = [NSString stringWithFormat:@"%@", option.objID];
    self.attribute.selectedOption = option;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setCurrentField:(UITextField *)currentField
{
    if(_currentField != nil){
        [_currentField resignFirstResponder];
    }
    _currentField = currentField;
}

#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)viewWillAppear:(BOOL)animated {
    if(self.attributesTableView != nil){
        // Unselect the selected row if any
        NSIndexPath *selection = [self.attributesTableView indexPathForSelectedRow];
        if (selection) {
            [self.attributesTableView deselectRowAtIndexPath:selection animated:YES];
        }
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.attributesTableView != nil){
        //	The scrollbars won't flash unless the tableview is long enough.
        [self.attributesTableView flashScrollIndicators];        
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if(self.attributesTableView != nil){
        [super setEditing:editing animated:animated];
        [self.attributesTableView setEditing:editing animated:animated];        
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(self.attributesTableView != nil){
        [self.attributesTableView flashScrollIndicators];        
    }

}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setupAddressInterface;
{
    /*
     [_footerButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button"] forState:UIControlStateNormal];
     [_footerButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button_highlight"] forState:UIControlStateHighlighted];
     */
    self.name.inputAccessoryView = self.accessoryView;
    self.address1.inputAccessoryView = self.accessoryView;
    self.address2.inputAccessoryView = self.accessoryView;
    self.city.inputAccessoryView = self.accessoryView;
    self.state.inputAccessoryView = self.accessoryView;
    self.zip.inputAccessoryView = self.accessoryView;
    
    
    [self.addressDoneButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button"] forState:UIControlStateNormal];
    [self.addressDoneButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button_highlight"] forState:UIControlStateHighlighted];
    
    CGRect addressViewRect = self.addressInterface.frame;
    addressViewRect.origin.y = self.headerView.frame.size.height+50;
    self.inputInterface.frame = addressViewRect;
    [self.view addSubview:self.addressInterface];
    [self.view addSubview:self.headerView];
    
//    self.name.text = self.attribute.
}
-(void)setupSelectInterface;
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.tableHeaderView = self.headerView;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    [self.view addSubview:tableView];
    self.attributesTableView = tableView;
}
-(void)setupInputInterface;
{
    NSLog(@"Setting up input interface: %@",self.inputInterface);
    self.input.inputAccessoryView = self.accessoryView;
    
    [self.inputDoneButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button"] forState:UIControlStateNormal];
    [self.inputDoneButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button_highlight"] forState:UIControlStateHighlighted];
    
    CGRect inputViewRect = self.inputInterface.frame;
    inputViewRect.origin.y = self.headerView.frame.size.height+10;
    self.inputInterface.frame = inputViewRect;
    [self.view addSubview:self.inputInterface];
    //[self.view addSubview:self.headerView];
}
-(void)removeInterfaces;
{
    if(self.currentField != nil){
        [self.currentField resignFirstResponder];
    }
    
    if(self.attributesTableView != nil){
        [self.attributesTableView removeFromSuperview];
    }
    if(self.inputInterface != nil){
        [self.inputInterface removeFromSuperview];
    }
    if(self.addressInterface != nil){
        [self.addressInterface removeFromSuperview];
    }

}

-(IBAction)doneWithAddress:(id)sender;
{
    if(self.currentField != nil){
        [self.currentField resignFirstResponder];
    }
    bool isOK = YES;
    if(self.name.text.length < 1){
        isOK = NO;
    }
    if(self.address1.text.length < 1){
        isOK = NO;
    }
    if(self.city.text.length < 1){
        isOK = NO;
    }
    if(self.state.text.length < 1){
        isOK = NO;
    }
    if(self.zip.text.length < 1){
        isOK = NO;
    }
    if(isOK == NO){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must fill in name, address, city, state and zip!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ECAttributeOption *option = [[ECAttributeOption alloc] init];
    option.option = self.address1.text;
    option.name = self.name.text;
    option.address1 = self.address1.text;
    option.address2 = self.address2.text;
    option.city = self.city.text;
    option.state = self.state.text;
    option.zip = self.zip.text;
    self.attribute.selectedOption = option;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)doneWithInput:(id)sender;
{
    if(self.currentField != nil){
        [self.currentField resignFirstResponder];
    }
    
    bool isOK = YES;
    if(self.input.text.length < 1){
        isOK = NO;
    }
    if(isOK == NO){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Value is required!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ECAttributeOption *option = [[ECAttributeOption alloc] init];
    option.inputValue = self.input.text;
    option.option = self.input.text;
    NSLog(@"Setting option value to %@", option.inputValue);
    [self.attribute setSelectedOption:option];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)next:(id)sender;
{
    if(self.currentField == self.state){
        //[self.currentField resignFirstResponder];
        [self.zip becomeFirstResponder];
    }
    
    if(self.currentField == self.city){
        //[self.city resignFirstResponder];
        [self.state becomeFirstResponder];
    }
    
    if(self.currentField == self.address2){
        // [self.address1 resignFirstResponder];
        [self.city becomeFirstResponder];
    }
    
    if(self.currentField == self.address1){
        // [self.address1 resignFirstResponder];
        [self.address2 becomeFirstResponder];
    }
    
    if(self.currentField == self.name){
        //[self.name resignFirstResponder];
        [self.address1 becomeFirstResponder];
    }
    
}
-(IBAction)prev:(id)sender;
{
    if(self.currentField == self.address1){
        [self.currentField resignFirstResponder];
        [self.name becomeFirstResponder];
    }
    if(self.currentField == self.address2){
        [self.currentField resignFirstResponder];
        [self.address1 becomeFirstResponder];
    }
    if(self.currentField == self.city){
        [self.currentField resignFirstResponder];
        [self.address2 becomeFirstResponder];
    }
    if(self.currentField == self.state){
        [self.currentField resignFirstResponder];
        [self.city becomeFirstResponder];
    }
    if(self.currentField == self.zip){
        [self.currentField resignFirstResponder];
        [self.state becomeFirstResponder];
    }
}
-(IBAction)done:(id)sender;
{
    if(self.attribute.attributeType == AttributeTypeInput){
        //Input and done.
        if(self.currentField != nil){
            [self.currentField resignFirstResponder];
        }
        return;
    }else{
        if(self.currentField != nil){
            [self.currentField resignFirstResponder];
        }
    }
}

#pragma MARK UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    self.currentField = textField;
    
    self.view.frame = CGRectMake(0, -textField.frame.origin.y+50, self.view.frame.size.width, self.view.frame.size.height);
    
    if(self.currentField == self.input){
        self.nextButton.enabled = NO;
        self.prevButton.enabled = NO;
        return;
    }
    self.nextButton.enabled = YES;
    self.prevButton.enabled = YES;
    if(self.currentField == self.name){
        self.prevButton.enabled = NO;
    }
    if(self.currentField == self.zip){
        self.nextButton.enabled = NO;
    }    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.currentField resignFirstResponder];
    self.currentField = nil;
    [textField resignFirstResponder];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
}

@end
