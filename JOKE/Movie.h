//
//  Movie.h
//  JOKE
//
//  Created by lanouhn on 15/8/3.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * movieImageName;
@property (nonatomic, retain) NSString * movieName;

@end
