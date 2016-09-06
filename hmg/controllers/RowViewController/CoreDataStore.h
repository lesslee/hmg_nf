//
//  CoreDataStore.h
//  hmg
//
//  Created by Lee on 15/3/30.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CoreDataStore : NSObject

+(id)defaultStore;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;

+ (void)savePrivateQueueContext;
+ (void)saveMainQueueContext;

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString;

@end


@interface NSManagedObject (Additions)

+(instancetype)findFirstByAttribute:(NSString *)attribute withValue:(id)value inContext:(NSManagedObjectContext *)context;

+(NSFetchRequest*)fetchRequest;

+(instancetype)insert:(NSManagedObjectContext *)context;


@end
