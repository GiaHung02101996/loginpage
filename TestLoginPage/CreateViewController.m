//
//  CreateViewController.m
//  TestLoginPage
//
//  Created by giahung on 7/6/23.
//

#import "CreateViewController.h"
@import FirebaseAuth;

@interface CreateViewController ()

@end

@implementation CreateViewController
@synthesize email, password;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)create:(id)sender {
    NSLog(@"%@", email.text);
    NSLog(@"%@",password.text);
    [[FIRAuth auth] createUserWithEmail:self.email.text
                           password:self.password.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        if(error){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:NULL];

        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notify" message:@"Create account successfully" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self dismissViewControllerAnimated:YES completion:NULL];
                [self performSegueWithIdentifier:@"HomePage" sender:self];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:NULL];
        }
    }];}
@end
