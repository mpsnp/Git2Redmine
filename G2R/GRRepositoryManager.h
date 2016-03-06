//
//  GRRepositoryManager.h
//  git2redmine
//
//  Created by George Kiriy on 03/03/16.
//  Copyright © 2016 Mpsnp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GitUpKit/GitUpKit.h>

static NSString *const kNotificationOpenRepository = @"openedRepository";

@interface GRRepositoryManager : NSObject
@property (nonatomic, strong) GCRepository *repo;

+ (GRRepositoryManager *)instance;
- (void)openRepository:(NSString *)path;
@end
