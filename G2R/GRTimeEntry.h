//
// Created by George Kiriy on 03/03/16.
// Copyright (c) 2016 Mpsnp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRIssue;
@class GRProject;

@interface GRTimeEntry : NSObject
@property (nonatomic, strong) GRIssue *issue;
@property (nonatomic, strong) GRProject *project;
@property (nonatomic, strong) NSNumber *hours;
@property (nonatomic, strong) NSDate *spentOn;
@property (nonatomic, strong) NSString *comments;

- (instancetype)initWithProject:(GRProject *)project hours:(NSNumber *)hours spentOn:(NSDate *)spentOn comments:(NSString *)comments;

+ (instancetype)entryWithProject:(GRProject *)project hours:(NSNumber *)hours spentOn:(NSDate *)spentOn comments:(NSString *)comments;

@end