//
//  GRAppDelegate.m
//  G2R
//
//  Created by George Kiriy on 02/03/16.
//  Copyright © 2016 Mpsnp. All rights reserved.
//

#import "GRAppDelegate.h"
#import "GRRepositoryManager.h"

@interface GRAppDelegate ()

@end

@implementation GRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)openRepository:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];

    NSInteger clicked = [panel runModal];

    if (clicked == NSFileHandlingPanelOKButton)
    {
        for (NSURL *url in [panel URLs])
        {
            [[GRRepositoryManager instance] openRepository:url.path];
        }
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
