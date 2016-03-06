//
//  GRViewController.m
//  G2R
//
//  Created by George Kiriy on 02/03/16.
//  Copyright © 2016 Mpsnp. All rights reserved.
//

#import "GRViewController.h"
#import "GRRepositoryManager.h"
#import "GRIssuesManager.h"
#import "GRProject.h"
#import "GRTimeEntry.h"
#import <GitUpKit/GitUpKit.h>
#import <GitUpKit/GCRepository.h>
#import <GitUpKit/GCHistory.h>

@interface GRViewController () <NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSComboBox *projectComboBox;
@property (weak) IBOutlet NSTextField *spentHours;
@property (weak) IBOutlet NSTextField *logMessage;
@property (nonatomic, strong) GCRepository *repository;
@property (nonatomic, strong) GCHistory *history;
@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) GRProject *selectedProject;
@end

@implementation GRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GRIssuesManager *manager = [GRIssuesManager managerWithBaseURL:[NSURL URLWithString:@"http://213.221.39.62:5555"]];
    [GRIssuesManager setSharedManager:manager];
    // Do any additional setup after loading the view.
}

- (IBAction)log:(id)sender
{
    NSIndexSet *indexes = self.tableView.selectedRowIndexes;
    GCCommit *firstCommit = _history.allCommits[indexes.firstIndex];
    GRTimeEntry *timeEntry = [GRTimeEntry entryWithProject:_selectedProject hours:@([_spentHours doubleValue]) spentOn:firstCommit.date comments:firstCommit.message];
    [[GRIssuesManager sharedManager] postObject:timeEntry path:@"/time_entries.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

    }];
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *eventChars = [theEvent charactersIgnoringModifiers];
    unichar keyChar = [eventChars characterAtIndex:0];
    
    if (( keyChar == NSEnterCharacter ) ||
        ( keyChar == NSCarriageReturnCharacter ))
    {
        [self log:nil];
    }
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    [[GRIssuesManager sharedManager] getProjectsWithCompletionHandler:^(NSArray *projects) {
        self.projects = projects;
        [self.projectComboBox reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRepository) name:kNotificationOpenRepository object:nil];
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)checkRepository
{
    GCRepository *repository = [[GRRepositoryManager instance] repo];
    self.repository = repository;
    self.history = [repository loadHistoryUsingSorting:kGCHistorySorting_ReverseChronological error:NULL];
    [self.tableView reloadData];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return self.projects.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    GRProject *project = self.projects[index];
    return project.name;
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    self.selectedProject = self.projects[(NSUInteger) _projectComboBox.indexOfSelectedItem];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.history.allCommits.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    GCCommit *commit = self.history.allCommits[(NSUInteger) row];
    if ([tableColumn.identifier isEqualToString:@"message"])
    {
        return commit.message;
    }
    if ([tableColumn.identifier isEqualToString:@"date"])
    {
        return [NSDateFormatter localizedStringFromDate:commit.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexSet *indexes = self.tableView.selectedRowIndexes;
    GCCommit *firstCommit = _history.allCommits[indexes.firstIndex];
    GCCommit *lastCommit = _history.allCommits[indexes.lastIndex];
    if (firstCommit == lastCommit)
    {
        lastCommit = _history.allCommits[indexes.firstIndex + 1];
    }

    NSDate *toDate = firstCommit.date;
    NSDate *sinceDate = lastCommit.date;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    enum NSCalendarUnit flags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *toComponents = [calendar components:flags fromDate:toDate];
    NSDateComponents *sinceComponents = [calendar components:flags fromDate:sinceDate];
    if (toComponents.day != sinceComponents.day && sinceComponents.hour >= 9)
    {
        sinceComponents.day = toComponents.day;
        sinceComponents.hour = 9;
        sinceComponents.minute = 0;
    }

    sinceDate = [calendar dateFromComponents:sinceComponents];

    NSTimeInterval secondsBetween = [toDate timeIntervalSinceDate:sinceDate];
    double hoursSpent = secondsBetween / 3600.0;
    [self.spentHours setDoubleValue:hoursSpent];
    [self.logMessage setStringValue:firstCommit.message];
}


- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
