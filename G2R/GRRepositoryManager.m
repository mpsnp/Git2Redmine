//
//  GRRepositoryManager.m
//  git2redmine
//
//  Created by George Kiriy on 03/03/16.
//  Copyright © 2016 Mpsnp. All rights reserved.
//

#import <GitUpKit/GitUpKit.h>
#import "GRRepositoryManager.h"

@interface GRRepositoryManager ()
@end

@implementation GRRepositoryManager
+ (GRRepositoryManager *)instance
{
    static GRRepositoryManager *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)openRepository:(NSString *)path
{
    self.repo = [[GCRepository alloc] initWithExistingLocalRepository:path error:NULL];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenRepository object:self];
}


@end
