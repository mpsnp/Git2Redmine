//
// Created by George Kiriy on 03/03/16.
// Copyright (c) 2016 Mpsnp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Network/RKObjectManager.h>


@interface GRIssuesManager : RKObjectManager
- (void)getProjectsWithCompletionHandler:(void (^)(NSArray *projects))completionHandler error:(void (^)(NSError *error))errorBlock;
- (void)postTimeEntryWithCompletionHandler:(void (^)(NSArray *projects))completionHandler error:(void (^)(NSError *error))errorBlock;
@end