    // Class under test
#import "AppDelegate.h"

    // Collaborators
#import "HMRI99ViewController.h"
#import "SessionsTableViewDataSource.h"

    // Test support
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface AppDelegateTests : SenTestCase
@end

@implementation AppDelegateTests
{
    UIWindow *window;
    UINavigationController *navigationController;
    AppDelegate *sut;
}

- (void) setUp
{
    [super setUp];
    window = [[UIWindow alloc] init];
    navigationController = [[UINavigationController alloc] init];
    sut = [[AppDelegate alloc] init];
//    sut.window = window;
//    sut.navigationController = navigationController;
}

- (void) tearDown
{
    window = nil;
//    navigationController = nil;
//    sut = nil;
    [super tearDown];
}

- (void)testWindowIsKeyAfterApplicationLaunch
{
    [sut application: nil didFinishLaunchingWithOptions: nil];
    assertThatBool(sut.window.keyWindow, is(equalToBool(YES)));
}

- (void)testWindowHasRootNavigationControllerAfterApplicationLaunch
{
    [sut application: nil didFinishLaunchingWithOptions: nil];
    assertThat(sut.window.rootViewController, is(notNilValue()));
}
         
- (void)testAppDidFinishLaunchingReturnsYES
{
    assertThatBool([sut application: nil didFinishLaunchingWithOptions: nil],is(equalToBool(YES)));
}

- (void)testNavigationControllerShowsAHMRI99ViewController
{
    [sut application: nil didFinishLaunchingWithOptions: nil];
    id visibleViewController = sut.navigationController.topViewController;
    assertThatBool([visibleViewController isKindOfClass: [HMRI99ViewController class]], is(equalToBool(YES)));
}

- (void)testFirstViewControllerHasASessionTableViewDataSource
{
    [sut application: nil didFinishLaunchingWithOptions: nil];
    HMRI99ViewController *viewController = (HMRI99ViewController *) sut.navigationController.topViewController;
    assertThatBool([viewController.dataSource isKindOfClass: [SessionsTableViewDataSource class]], is(equalToBool(YES)));
}


@end
