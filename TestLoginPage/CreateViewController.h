//
//  CreateViewController.h
//  TestLoginPage
//
//  Created by giahung on 7/6/23.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface CreateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)create:(id)sender;

@end

//NS_ASSUME_NONNULL_END
