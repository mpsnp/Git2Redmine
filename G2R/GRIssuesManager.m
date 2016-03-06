//
// Created by George Kiriy on 03/03/16.
// Copyright (c) 2016 Mpsnp. All rights reserved.
//

#import "GRIssuesManager.h"
#import "GRTimeEntry.h"
#import "GRProject.h"
#import "RKISO8601DateFormatter.h"
#import <RestKit/RestKit.h>

@implementation GRIssuesManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self registerDescriptors];
    }

    return self;
}

- (instancetype)initWithHTTPClient:(AFHTTPClient *)client
{
    self = [super initWithHTTPClient:client];
    if (self)
    {
        [self registerDescriptors];
    }

    return self;
}


- (void)registerDescriptors
{
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[GRProject class]];
    [projectMapping addAttributeMappingsFromDictionary:@{@"id" : @"projectId", @"name" : @"name", @"identifier" : @"identifier"}];
    RKResponseDescriptor *projectDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"projects" statusCodes:nil];


//    @property (nonatomic, strong) GRIssue *issue;
//    @property (nonatomic, strong) GRProject *project;
//    @property (nonatomic, strong) NSNumber *hours;
//    @property (nonatomic, strong) NSDate *spentOn;
//    @property (nonatomic, strong) NSString *comments;
    [RKObjectMapping setPreferredDateFormatter:[RKISO8601DateFormatter new]];
    RKObjectMapping *timeMapping = [RKObjectMapping mappingForClass:[GRTimeEntry class]];
    [timeMapping addAttributeMappingsFromDictionary:@{@"project_id" : @"project.projectId", @"hours" : @"hours", @"spent_on" : @"spentOn", @"comments" : @"comments"}];

    RKObjectMapping *mapping = [timeMapping inverseMapping];
    RKRequestDescriptor *timeRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[GRTimeEntry class] rootKeyPath:@"time_entry" method:RKRequestMethodPOST];

    [self addResponseDescriptorsFromArray:@[projectDescriptor]];
    [self addRequestDescriptor:timeRequestDescriptor];
}

- (void)getProjectsWithCompletionHandler:(void (^)(NSArray *projects))completionHandler error:(void (^)(NSError *error))errorBlock
{
    [self getObjectsAtPath:@"/projects.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completionHandler)
        {
            completionHandler(mappingResult.array);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
}


@end