//
//  IntroLayer.m
//  Coco2DSimpleGame
//
//  Created by Franco Arolfo on 9/9/13.
//  Copyright Franco Arolfo 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
    layer.touchEnabled = YES;
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite * background;
        
        background = [CCSprite spriteWithFile:@"initialBackground.jpg"];
		background.position = ccp(size.width/2, size.height/2);
        
        [self addChild: background z:0];
	}
	
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HelloWorldLayer sceneFromLevel: 1 withLifes:5] ]];
}

@end
