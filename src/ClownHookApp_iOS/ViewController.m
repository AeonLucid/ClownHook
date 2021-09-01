#import "ViewController.h"
#import "clown.h"

void (*orig_NSLog)(NSString *fmt, ...) = NULL;

void my_NSLog(NSString *fmt, ...) {
    orig_NSLog(@"Called original NSLog");

    NSString *newFmt = [NSString stringWithFormat: @"[Patched]: %@", fmt];

    va_list ap;
    va_start(ap, fmt);
    NSLogv(newFmt, ap);
    va_end(ap);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hello, this is a test.");

    clown_init();
    clown_hook(NSLog, my_NSLog, (void **) &orig_NSLog);

    NSLog(@"Test while hooked.");
}


@end
