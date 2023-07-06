//
//  ViewController.h
//  TestLoginPage
//
//  Created by giahung on 6/25/23.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;

@end

