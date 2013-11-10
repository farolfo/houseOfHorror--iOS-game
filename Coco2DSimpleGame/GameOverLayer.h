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

+(CCScene *) sceneWithWon:(BOOL)won inLevel: (int) level withLifes: (int) lifes;
- (id)initWithWon:(BOOL)won inLevel: (int) level withLifes: (int) lifes;
- (NSString *) getMessageWithLevel: (int) level;

@end
