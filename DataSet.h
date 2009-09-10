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
	
	BOOL *brushed;
}

@property (nonatomic, readonly) NSArray *dimensions;

@property (nonatomic, readonly) BOOL *brushed;

- (int)numValues;

- (void)brushByDimension:(int)axis from:(float)normalizedMin to:(float)normalizedMax;

- (void)resetBrush;

@end
