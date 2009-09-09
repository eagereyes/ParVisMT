//
//  DataSet.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DataSet : NSObject {

	NSMutableArray *dimensions;
	
}

@property (nonatomic, readonly) NSArray *dimensions;


- (int)numValues;

@end
