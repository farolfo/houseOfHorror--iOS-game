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
    int _monstersDestroyed;
    
    int _lifes;
    
}

@property (nonatomic) int score;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
