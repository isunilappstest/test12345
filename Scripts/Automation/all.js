#import "tuneup/tuneup.js"

test("Sign-in screen should be accessible with certain fields and cancelable", function(target, app) {
  mainWindow = app.mainWindow();
  mainWindow.tabBar().buttons()["Account"].tap();
  UIALogger.logMessage('Tapping sign-in button...');
  signinButton = mainWindow.navigationBar().buttons()['Sign-in'];
  assertNotNull(signinButton, "Couldn't find sign-in navigation button.");
  signinButton.tap();
  signinButton.waitForInvalid();
  
  UIALogger.logMessage('Checking for valid fields...');
  table = mainWindow.tableViews()[0];
  userName = table.cells().firstWithName("Email");
  assertNotNull(userName, "Couldn't find email field");
  userName.textFields()[0].setValue("billiejoe@example.com");
  
  password = table.cells().firstWithName("Password");
  assertNotNull(password, "Couldn't find password field");
  assertNotNull(password.secureTextFields()[0], "Couldn't find secure text field for password");
  password.secureTextFields()[0].setValue("wootwoot");
  
  UIALogger.logMessage('Canceling sign-in process...');
  backButton = mainWindow.navigationBar().buttons()["Cancel"];
  assertNotNull(backButton, "Couldn't find cancel button.");
  backButton.tap();
});


test("Sign-up screen should be accessible from sign-in screen and have fields", function(target, app) {
  mainWindow = app.mainWindow();
  mainWindow.tabBar().buttons()["Account"].tap();
  UIALogger.logMessage('Tapping sign-in button...');
  var signinButton = mainWindow.navigationBar().buttons()['Sign-in'];
  signinButton.tap();
  signinButton.waitForInvalid();
  
  UIALogger.logMessage('Checking for sign-up button...');
  table = mainWindow.tableViews()[0];
  signupButton = table.cells().firstWithName("I need an account.");
  assertNotNull(signupButton, "Couldn't find signup button.");
  signupButton.tap();
  
  UIALogger.logMessage('Checking for valid fields...');
  table = mainWindow.tableViews()[1];
  userName = table.cells().firstWithName("Email");
  assertNotNull(userName, "Couldn't find email field");
  assertNotNull(userName.textFields()[0], "Couldn't find text field for email");
  userName.textFields()[0].setValue("billiejoe@example.com");
  
  password = table.cells().firstWithName("Password");
  assertNotNull(password, "Couldn't find password field");
  assertNotNull(password.secureTextFields()[0], "Couldn't find secure text field for password");
  password.secureTextFields()[0].setValue("wootwoot");
  
  firstName = table.cells().firstWithName("First name");
  assertNotNull(firstName, "Couldn't find first name field");
  assertNotNull(firstName.textFields()[0], "Couldn't find text field for first name");
  firstName.textFields()[0].setValue("Billie Joe");
  
  lastName = table.cells().firstWithName("Last name");
  assertNotNull(lastName, "Couldn't find last name field");
  assertNotNull(lastName.textFields()[0], "Couldn't find text field for last name");
  lastName.textFields()[0].setValue("Armstrong");
  
  UIALogger.logMessage('Canceling sign-up process...');
  backButton = mainWindow.navigationBar().buttons()["Sign-in"];
  assertNotNull(backButton, "Couldn't find cancel button.");
  backButton.tap();
  
  UIALogger.logMessage('Canceling sign-in process...');
  cancelButton = mainWindow.navigationBar().buttons()["Cancel"];
  assertNotNull(cancelButton, "Couldn't find cancel button.");
  cancelButton.tap();
});