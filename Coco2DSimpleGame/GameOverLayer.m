//
//  GameOverLayer.m
//  Coco2DSimpleGame
//
//  Created by Franco Arolfo on 9/12/13.
//  Copyright 2013 Franco Arolfo. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "IntroLayer.h"

@implementation GameOverLayer


+(CCScene *) sceneWithWon:(BOOL)won inLevel: (int) level withLifes: (int) lifes{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won inLevel:level withLifes:lifes];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won inLevel: (int) level withLifes: (int) lifes{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        NSString * message;
        
        if (won) {
            message = [self getMessageWithLevel: level];
        } else {
            message = @"You Lose :[";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        int nextLevel, nextLifes;
        
        nextLevel = level + 1;
        nextLifes = lifes;
        
        CCScene * nextLayer;
        if ( (won && level == 3) || ! won  ) {
            nextLayer = [IntroLayer scene];
        } else {
            nextLayer = [HelloWorldLayer sceneFromLevel: nextLevel withLifes:nextLifes];
        }

        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene: nextLayer];
         }],
          nil]];

    
    }
    return self;
}

- (NSString *) getMessageWithLevel: (int) level
{
    NSString * message;
    if ( level == 3 ) {
        message = @"You won !!";
    } else {
        message = [NSString stringWithFormat:@"You've passed to level %d...", ++level];
    }
    return message;
}

@end
