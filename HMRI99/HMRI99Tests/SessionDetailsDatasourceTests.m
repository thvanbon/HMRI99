
    // Class under test
#import "SessionDetailsDataSource.h"

    // Collaborators
#import "Session.h"
    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionDetailsDatasourceTests : SenTestCase
@end

@implementation SessionDetailsDatasourceTests
{
    SessionDetailsDataSource * sut;
    Session *sampleSession;
    UITextField *textField;
    NSDateFormatter *formatter;
    NSDate *myDate;
}

- (void) setUp
{
    [super setUp];
    sut=[[SessionDetailsDataSource alloc] init];
    sampleSession=[[Session alloc] init];
    sut.session=sampleSession;
    formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
}

- (void) tearDown
{
    sut=nil;
    sampleSession=nil;
    textField=nil;
    formatter=nil;
    [super tearDown];
}

- (void) testNumberOfSectionsReturnsOne
{
    assertThatInt([sut numberOfSectionsInTableView:nil],is(equalToInt(1)));
}

- (void) testNumberOfRowsReturnsFourForFirstSection
{
    assertThatInt([sut tableView:nil numberOfRowsInSection:0],is(equalToInt(4)));
}

- (void) testObjectShouldConformToUITextFieldDelegate
{
    assertThat(sut, conformsTo(@protocol(UITextFieldDelegate)));
}

- (void) testTextFieldDidBeginEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidBeginEditing:)],is(equalToBool(YES)));
}

- (void) testTextFieldDidEndEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidEndEditing:)],is(equalToBool(YES)));
}

#pragma mark row 0

- (void) testCellOnRow0HasTextLabelProjectName
{
    assertThat([[self textLabelForRow:0] text], is(equalTo(@"Name")));
}

- (void) testCellOnRow0HasTextFieldWithProjectNamePlaceholder
{
    assertThat([[self textFieldForRow:0] placeholder], is(equalTo(@"eg. ABC.14.01")));
}

- (void) testCellOnRow0HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:0]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testCellOnRow0HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:0]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsProjectNameTextFieldDelegate
{
    assertThat([[self textFieldForRow:0] delegate], is(equalTo(sut)));
}

- (void) testChangingProjectNameTextFieldUpdatesSessionProjectName
{
    [self updateRow:0 withInsertedSampleText:@"CARG.14.01"];
    assertThat([[sut session] name],is(equalTo(@"CARG.14.01")));
}

- (void) testProjectNameTextFieldShowsProjectName
{
    sut.session.name=@"ABC.14.01";
    assertThat([[self textFieldForRow:0] text], is(equalTo(@"ABC.14.01")));
}

#pragma mark row 1

- (void) testCellOnRow1HasTextLabelProjectName
{
    assertThat([[self textLabelForRow:1] text], is(equalTo(@"Date")));
}

- (void) testCellOnRow1HasTextFieldWithProjectNamePlaceholder
{
    assertThat([[self textFieldForRow:1] placeholder], is(equalTo(@"-")));
}

- (void) testCellOnRow1HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:1]keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) tesCellOnRow1HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:1]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDateTextFieldDelegate
{
    assertThat([[self textFieldForRow:1] delegate], is(equalTo(sut)));
}

- (void) testChangingDateTextFieldUpdatesSessionDate
{
    NSString *myText=[formatter stringFromDate:myDate];
    [self updateRow:1 withInsertedSampleText:myText];
    assertThat([[sut session] date],is(equalTo([formatter dateFromString:myText])));
}

- (void) testProjectDateTextFieldShowsDate
{  
    sut.session.date=myDate;
    assertThat([[self textFieldForRow:1] text], is(equalTo([formatter stringFromDate:myDate])));
}


#pragma mark row 2

- (void) testCellOnRow2HasTextLabelLocation
{
    assertThat([[self textLabelForRow:2] text], is(equalTo(@"Location")));
}

- (void) testCellOnRow2HasTextFieldWithLocationPlaceholder
{
    assertThat([[self textFieldForRow:2] placeholder], is(equalTo(@"eg. Aalsmeer")));
}

- (void) testCellOnRow2HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:2]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testCellOnRow2HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:2]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsLocationTextFieldDelegate
{
    assertThat([[self textFieldForRow:2] delegate], is(equalTo(sut)));
}

- (void) testChangingLocationTextFieldUpdatesSessionLocation
{
    [self updateRow:2 withInsertedSampleText:@"Zaandam"];
    assertThat([[sut session] location],is(equalTo(@"Zaandam")));
}

- (void) testLocationTextFieldShowsLocation
{
    sut.session.location=@"Amsterdam";
    assertThat([[self textFieldForRow:2] text], is(equalTo(@"Amsterdam")));
}

#pragma mark row 3

- (void) testCellOnRow3HasTextLabelEngineer
{
    assertThat([[self textLabelForRow:3] text], is(equalTo(@"Engineer")));
}

- (void) testCellOnRow3HasTextFieldWithEngineerPlaceholder
{
    assertThat([[self textFieldForRow:3] placeholder], is(equalTo(@"eg. ABc")));
}

- (void) testCellOnRow3HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:3]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testCellOnRow3HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:3]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsEngineerTextFieldDelegate
{
    assertThat([[self textFieldForRow:3] delegate], is(equalTo(sut)));
}

- (void) testChangingEngineerTextFieldUpdatesSessionEngineer
{
    [self updateRow:3 withInsertedSampleText:@"ABc"];
    assertThat([[sut session] engineer],is(equalTo(@"ABc")));
}

- (void) testEngineerTextFieldShowsEngineer
{
    sut.session.engineer=@"DEf";
    assertThat([[self textFieldForRow:3] text], is(equalTo(@"DEf")));
}

#pragma mark helper methods

-(UITableViewCell *)cellForRow:(int)row
{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    return [sut tableView:nil cellForRowAtIndexPath:indexPath];
}

-(UITextField *)textFieldForRow:(int)row
{
    return (UITextField *) [[self cellForRow:row] viewWithTag:row+1];
}

-(UILabel *)textLabelForRow:(int)row
{
    return (UILabel *) [[self cellForRow:row] textLabel];
}

- (void)updateRow:(int)row withInsertedSampleText:(NSString *)insertedSampleText
{
    textField=[self textFieldForRow:row];
    [sut textFieldDidBeginEditing:textField];
    textField.text=insertedSampleText;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField];
    [sut textFieldDidEndEditing:textField];
}

- (NSString *)formatDate:(NSDate *)myNewDate
{
    NSString *stringFromDate = [formatter stringFromDate:myNewDate];
    return stringFromDate;
}


@end
