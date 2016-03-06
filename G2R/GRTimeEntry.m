//
// Created by George Kiriy on 03/03/16.
// Copyright (c) 2016 Mpsnp. All rights reserved.
//

#import "GRTimeEntry.h"
#import "GRIssue.h"
#import "GRProject.h"


@implementation GRTimeEntry
{

}
- (instancetype)initWithProject:(GRProject *)project hours:(NSNumber *)hours spentOn:(NSDate *)spentOn comments:(NSString *)comments
{
    self = [super init];
    if (self)
    {
        self.project = project;
        self.hours=hours;
        self.spentOn=spentOn;
        self.comments=comments;
    }

    return self;
}

+ (instancetype)entryWithProject:(GRProject *)project hours:(NSNumber *)hours spentOn:(NSDate *)spentOn comments:(NSString *)comments
{
    return [[self alloc] initWithProject:project hours:hours spentOn:spentOn comments:comments];
}

@end