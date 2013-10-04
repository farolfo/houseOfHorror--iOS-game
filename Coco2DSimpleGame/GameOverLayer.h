//
//  GameOverLayer.h
//  Coco2DSimpleGame
//
//  Created by Franco Arolfo on 9/12/13.
//  Copyright 2013 Franco Arolfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

+(CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
