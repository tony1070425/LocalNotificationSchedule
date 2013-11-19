//
//  ViewController.m
//  LocalNotificationSchedule
//
//  Created by Peter on 13/10/22.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UITextField *eventText;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation ViewController

#pragma mark - Refresh TableVIew

- (void)refreshTableView:(NSNotification *)notification
{
    [self.listTableView reloadData];
}

#pragma mark - View



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"Refresh" object:nil]; 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notif = [notifs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"(%d) %@",notif.applicationIconBadgeNumber, notif.alertBody];
    //cell.detailTextLabel.text = notif.timeZone;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.detailTextLabel.text = [dateFormat stringFromDate:notif.fireDate];
    
    return cell;
}
#pragma mark - AddedMethods

- (IBAction)scheduleAction:(id)sender {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [self.dataPicker date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = self.eventText.text;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate ReorderApplicationIconBadgeNumber];
    
    [self.listTableView reloadData];
    self.eventText.text = @" ";
    [self.eventText resignFirstResponder];
    
//    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    
//    NSLog(@"%@", notifs);
//    NSLog(@"%@", localNotif.alertBody);
}
- (IBAction)TextDoneAction:(id)sender {
 //   [sender resignFirstResponder];
    self.eventText.text = @"";
}

@end
