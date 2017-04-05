//
//  AttributesSelectionViewController.h
//  Everlong
//
//  Created by Jason Cox on 9/27/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECAttribute;
@interface AttributesSelectionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *attributesTableView;
@property(nonatomic, retain) IBOutlet UIView *addressInterface;
@property(nonatomic, retain) IBOutlet UIView *inputInterface;

@property (nonatomic, retain) ECAttribute *attribute;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property(nonatomic, retain) IBOutlet UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UILabel *inputNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *descriptionLabel;

@property(nonatomic, retain) IBOutlet UITextField *input;

@property(nonatomic, retain) IBOutlet UITextField *name;
@property(nonatomic, retain) IBOutlet UITextField *address1;
@property(nonatomic, retain) IBOutlet UITextField *address2;
@property(nonatomic, retain) IBOutlet UITextField *city;
@property(nonatomic, retain) IBOutlet UITextField *state;
@property(nonatomic, retain) IBOutlet UITextField *zip;

@property(nonatomic, retain) NSNumber *quantityToBuy;

@property(nonatomic, retain) IBOutlet UIButton *addressDoneButton;
@property(nonatomic, retain) IBOutlet UIButton *inputDoneButton;

@property(nonatomic, retain) IBOutlet UIToolbar *accessoryView;

@property(nonatomic, retain) UITextField *currentField;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;




-(IBAction)doneWithAddress:(id)sender;
-(IBAction)doneWithInput:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)prev:(id)sender;
-(IBAction)done:(id)sender;

@end
