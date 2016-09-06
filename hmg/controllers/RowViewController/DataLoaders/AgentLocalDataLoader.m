//
//  AgentLocalDataLoader.m
//  hmg
//
//  Created by Lee on 15/3/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "AgentLocalDataLoader.h"
#import "Agent.h"
#import "Agent+Additions.h"
#import "CoreDataStore.h"
@implementation AgentLocalDataLoader
{
    NSString *_searchString;
}

- (id)init {
    self = [super init];
    if (self) {
        NSFetchedResultsController * fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Agent getFetchRequest]
                                                                                                 managedObjectContext:[CoreDataStore mainQueueContext]
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:nil];
        [self setFetchedResultsController:fetchResultController];
        
    }
    return self;
}

-(void)changeSearchString:(NSString *)searchString
{
    _searchString = searchString;
    [self refreshPredicate];
}

- (void)refreshPredicate
{
    [self setPredicate:[Agent getPredicateBySearchInput:_searchString]];
}



@end
