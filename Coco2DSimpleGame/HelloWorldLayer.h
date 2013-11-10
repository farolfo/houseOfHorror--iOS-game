//
//  HelloWorldLayer.h
//  Coco2DSimpleGame
//
//  Created by Franco Arolfo on 9/9/13.
//  Copyright Franco Arolfo 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
    NSMutableArray * _lifeNodes;
    int _monstersDestroyed;
    Boolean _cheatMode;
    int _lifes;
    int _level;
    int _combo;
}

-(id) initWithLevel: (int) level withLifes: (int) lifes;

@property (nonatomic) int score;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneFromLevel: (int) level withLifes: (int) lifes;

@end
