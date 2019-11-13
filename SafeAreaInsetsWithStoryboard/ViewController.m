//
//  ViewController.m
//  SafeAreaInsetsWithStoryboard
//
//  Created by Karol Szafrański on 13.11.19.
//  Copyright © 2019 Karol Szafrański. All rights reserved.
//

#import "ViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/utsname.h>

@interface ViewController ()

@property (strong, nonatomic) UILabel* infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.infoLabel = [UILabel new];
    self.infoLabel.numberOfLines = 0;
    [self.view addSubview:self.infoLabel];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20.0].active = YES;
    [self.infoLabel.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor constant:20.0].active = YES;
    [self.infoLabel.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:20.0].active = YES;
    [self.infoLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:20.0].active = YES;
}

- (void)updateInfoLabel {
    NSMutableArray* components = [[NSMutableArray alloc] initWithCapacity:3];
    [components addObject:[NSString stringWithFormat:@"model: \"%@\"", [self modelString]]];
    [components addObject:[NSString stringWithFormat:@"orientation: \"%@\"", [self currentOrientationString]]];

    NSMutableArray* insetsComponents = [[NSMutableArray alloc] initWithCapacity:4];
    [insetsComponents addObject:[NSString stringWithFormat:@"top: %f", self.view.safeAreaInsets.top]];
    [insetsComponents addObject:[NSString stringWithFormat:@"right: %f", self.view.safeAreaInsets.right]];
    [insetsComponents addObject:[NSString stringWithFormat:@"bottom: %f", self.view.safeAreaInsets.bottom]];
    [insetsComponents addObject:[NSString stringWithFormat:@"left: %f", self.view.safeAreaInsets.left]];

    NSString* insets = [NSString stringWithFormat:@"{%@}", [insetsComponents componentsJoinedByString:@", "]];
    [components addObject:insets];

    NSString* infoText = [NSString stringWithFormat:@"{%@}", [components componentsJoinedByString:@", "]];
    self.infoLabel.text = infoText;
    NSLog(@"\n%@", infoText);
}

- (NSString *)modelString {
//    int mib[] = {CTL_HW, HW_MACHINE};
//    size_t stringLength = 0;
//    sysctl(mib, 2, NULL, &stringLength, NULL, 0);
//    char *machine = malloc(stringLength);
//    sysctl(mib, 2, machine, &stringLength, NULL, 0);
//    NSString* model = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
//    free(machine);
//    return model;
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString*)currentOrientationString {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        return @"portrait";
    }
    return @"landscape";
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self updateInfoLabel];
}


@end
