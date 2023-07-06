//
//  ViewController.m
//  TestLoginPage
//
//  Created by giahung on 6/25/23.
//

#import "ViewController.h"
@import FirebaseAuth;
@interface ViewController ()

@end

@implementation ViewController
@synthesize email, password;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)login:(id)sender {
    NSLog(@"%@", email.text);
    NSLog(@"%@",password.text);
    [[FIRAuth auth] signInWithEmail:self.email.text
                           password:self.password.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.description);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:NULL];

        }
        else{
            [self performSegueWithIdentifier:@"submit" sender:self];
        }
    }];
}
@end
