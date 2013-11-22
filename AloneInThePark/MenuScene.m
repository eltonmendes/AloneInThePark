//
//  MenuScene.m
//  AloneInThePark
//
//  Created by Elton Mendes on 22/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"

@implementation MenuScene
SKSpriteNode *startButton;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *backgroundMenu = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundMenu.jpg"];
        [backgroundMenu setPosition:CGPointMake(160, 300)];
        [backgroundMenu setScale:0.5];
        [self addChild:backgroundMenu];
        
        
        startButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
        [startButton setPosition:CGPointMake(160, 280)];
        [startButton setScale:0.1];
        [self addChild:startButton];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for(UITouch *touch in touches){
        CGPoint touchLocation = [touch locationInNode:self];
        if(CGRectContainsPoint(startButton.frame, touchLocation)){
            [startButton setAlpha:0.5];
            [self startGame];
        }

    }
}

-(void)startGame{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    //Transition
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];

    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
   // [skView presentScene:scene];
    [self.scene.view presentScene: scene transition: reveal];

}
@end
