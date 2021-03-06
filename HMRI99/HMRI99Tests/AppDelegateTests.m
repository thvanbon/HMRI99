    // Class under test
#import "AppDelegate.h"

    // Collaborators
#import "SessionsViewController.h"
#import "SessionsTableViewDataSource.h"

    // Test support
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface AppDelegateTests : XCTestCase
@end

@implementation AppDelegateTests
{
    UIWindow *window;
    UINavigationController *navigationController;
    AppDelegate *sut;
    UIApplication *app;
}

- (void) setUp
{
    [super setUp];
    window = [[UIWindow alloc] init];
    navigationController = [[UINavigationController alloc] init];
    sut = [[AppDelegate alloc] init];
    app = [UIApplication sharedApplication];
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
    [sut application: app didFinishLaunchingWithOptions: nil];
    assertThatBool(sut.window.keyWindow, is(equalToLong(YES)));
}

- (void)testWindowHasRootNavigationControllerAfterApplicationLaunch
{
    [sut application: app didFinishLaunchingWithOptions: nil];
    assertThat(sut.window.rootViewController, is(notNilValue()));
}
         
- (void)testAppDidFinishLaunchingReturnsYES
{
    assertThatBool([sut application: app didFinishLaunchingWithOptions: nil],is(equalToLong(YES)));
}

- (void)testNavigationControllerShowsAHMRI99ViewController
{
    [sut application: app didFinishLaunchingWithOptions: nil];
    id visibleViewController = sut.navigationController.topViewController;
    assertThatBool([visibleViewController isKindOfClass: [SessionsViewController class]], is(equalToLong(YES)));
}

- (void)testFirstViewControllerHasASessionTableViewDataSource
{
    [sut application: app didFinishLaunchingWithOptions: nil];
    SessionsViewController *viewController = (SessionsViewController *) sut.navigationController.topViewController;
    assertThatBool([viewController.dataSource isKindOfClass: [SessionsTableViewDataSource class]], is(equalToLong(YES)));
}


@end
