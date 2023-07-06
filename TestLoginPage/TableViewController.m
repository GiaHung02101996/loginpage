//
//  TableViewController.m
//  TestLoginPage
//
//  Created by giahung on 6/25/23.
//

#import "TableViewController.h"

@interface TableViewController ()<UIAlertViewDelegate>
@property (atomic) NSMutableArray *items;
@property (atomic) NSMutableArray *categories;
//@property (atomic) NSMutableArray *data;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
//
//    if (self.data != nil ){
//        NSLog(@"Data exist");
//        NSLog(@"%@", self.data);
//        self.items = self.data;
//    }
//    else{
//        self.items = @[].mutableCopy;
//    }
    self.items = @[].mutableCopy;
    NSLog(@"%@", self.items);
    self.categories = @[].mutableCopy;
    self.navigationItem.title = @"To-do List";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"HomePage" style:UIBarButtonItemStylePlain target:self action:@selector(homepage:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
}
#pragma mark - Back to HomePage
-(void)homepage:(UIBarButtonItem *)sender{
    NSLog(@"Testing");
    [self performSegueWithIdentifier:@"HomePage" sender:self];
}
//#pragma mark - Go To Back
//-(void)goback:(UIBarButtonItem *)sender{
//    NSLog(@"Back");
//}
#pragma mark - Add new item
-(void)addNewItem:(UIBarButtonItem *)sender{
    // Create a pop-up when click Add button
    UIAlertController  *aleartView = [UIAlertController alertControllerWithTitle:@"To-do item" message:@"new item to add" preferredStyle:UIAlertControllerStyleAlert];
    [aleartView addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Enter the category";
    }];
    [aleartView addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Enter the thing you will do";
    }];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *itemNameCategory = aleartView.textFields.firstObject;
        UITextField *itemNameField = aleartView.textFields.lastObject;
        NSString *categoryName = itemNameCategory.text.uppercaseString;
        NSString *itemName = itemNameField.text;
        NSDictionary *item = @{@"name": itemName, @"category": categoryName};
        [self.items addObject:item];
        NSInteger numberHomeItem = [self numberOfItemsInCategory:categoryName];
        NSInteger indexForCategory = [self.categories indexOfObject:categoryName];
        if (indexForCategory == NSNotFound){
            [self.categories addObject:categoryName];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.categories.count - 1] withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numberHomeItem - 1 inSection:indexForCategory]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [aleartView addAction:add];
    [aleartView addAction:cancel];
    [self presentViewController:aleartView animated:YES completion:nil];
}
#pragma mark - Implement Category
- (NSArray *)itemsInCategory:(NSString *)targetCategory{
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category==%@", targetCategory];
    NSArray *categoryItems = [self.items filteredArrayUsingPredicate:matchingPredicate];
    return categoryItems;
}

- (NSInteger)numberOfItemsInCategory:(NSString *)targetCategory{
    return [self itemsInCategory:targetCategory].count;
}

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryItems = [self itemsInCategory:category];
    NSDictionary *item = categoryItems[indexPath.row];
    return item;
}

- (NSInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSLog(@"3");
    return self.categories[section];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%d",[self numberOfItemsInCategory:self.categories[section]]);
    return [self numberOfItemsInCategory:self.categories[section]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentify = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify forIndexPath:indexPath];
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    cell.textLabel.text = item[@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    self.items[index] = item;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Remove Item at IndexPath
-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    [self.items removeObjectAtIndex:index];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self removeItemAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
