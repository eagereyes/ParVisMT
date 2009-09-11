//
//  ParCoordsBackgroundLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "DataSet.h"
#import "DataDimension.h"

extern const int HPADDING;
extern const int TOPPADDING;
extern const int BOTTOMPADDING;

@interface ParCoordsBackgroundLayer : CALayer {

	DataSet *dataSet;
	
}

- (id)initWithDataSet:(DataSet *)d;


@end
