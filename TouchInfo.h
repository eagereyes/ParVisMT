//
//  TouchInfo.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TouchInfo : NSObject {

	float x;
	
	float y;
}

@property (nonatomic, assign) float x;

@property (nonatomic, assign) float y;

- (id)initWithInitialX:(float)initialX Y:(float)initialY;

- (NSComparisonResult)compareX:(TouchInfo *)other;

@end
