//
//  MyScene.m
//  AloneInThePark
//
//  Created by Elton Mendes on 14/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "MyScene.h"
#import "Joystick.h"
@implementation MyScene

Joystick *joystick;
SKSpriteNode *pad;
SKNode *world;
SKSpriteNode *backgroundScenario;

BOOL isJumping;
BOOL isGrounded;
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        isGrounded = true;
        
        backgroundScenario = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        backgroundScenario.anchorPoint = CGPointZero;
        [self addChild:backgroundScenario];
        
        world = [[SKNode alloc]init];
        [self addChild:world];


        
        [self createSceneContents];
        self.playerNode = [SKSpriteNode spriteNodeWithImageNamed:@"player.png"];
        self.playerNode.position = CGPointMake(50,320);
        [self.playerNode setScale:0.5];
        self.playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.playerNode.size.width/2];
        self.playerNode.physicsBody.dynamic = YES;

        [self addChild: self.playerNode];
        
        SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.jpg"];
        floor.position = CGPointMake(100, 200);
        floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1024, 80)];
        floor.physicsBody.dynamic = NO;
        floor.physicsBody.affectedByGravity = false;
        
        [world addChild:floor];
        
        //Joystick
        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick.png"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
        joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        joystick.position = CGPointMake(30, 220);
        [self addChild:joystick];
        
        //Keypad
        
        pad = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton.png"];
        [pad setScale:0.05];
        pad.position = CGPointMake(270, 220);
        [self addChild:pad];
        

        
    }
    return self;
}
- (void)didSimulatePhysics
{
    [self centerOnNode: [self childNodeWithName: @"//camera"]];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y - cameraPositionInScene.y);
}
- (void) createSceneContents
{
    //    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeResizeFill;
    //    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for(UITouch *touch in touches){
        CGPoint touchLocation = [touch locationInNode:self];
        if(CGRectContainsPoint(pad.frame, touchLocation) && isGrounded){
            isGrounded = false;
            CGPoint jumpPoint =  CGPointMake(self.playerNode.position.x, self.playerNode.position.y + 50);
            SKAction *jumpAction = [SKAction moveTo:jumpPoint duration:0.2];
            [self.playerNode runAction:jumpAction completion:^{
                [self performSelectorInBackground:@selector(setGrounded) withObject:NO];
            }];
        }
        

    }
    
    
}

-(void) setGrounded{
   
    [NSThread sleepForTimeInterval:0.3];
    isGrounded = true;

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //Ground Position:
    
    if(joystick.velocity.x > 0){
        CGPoint location = CGPointMake(self.playerNode.position.x + (joystick.velocity.x * 0.05), self.playerNode.position.y);
        self.playerNode.position = location;
        self.playerNode.xScale = 0.5;
        //Camera Follow
        SKAction *sceneFollow = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 2), world.position.y) duration:0.1];
        [world runAction:sceneFollow];

        
        SKAction *backgroundParallax = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 0.01), world.position.y) duration:0.1];
        
        [backgroundScenario runAction:backgroundParallax];

    }
    else if (joystick.velocity.x < 0){
        CGPoint location = CGPointMake(self.playerNode.position.x + (joystick.velocity.x * 0.05), self.playerNode.position.y);
        if(location.x >12){
            self.playerNode.position = location;
            self.playerNode.xScale = -0.5;
        }
        SKAction *sceneFollow = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 2), world.position.y) duration:0.1];
        [world runAction:sceneFollow];
        
        SKAction *backgroundParallax = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 0.01), world.position.y) duration:0.1];

        [backgroundScenario runAction:backgroundParallax];
        
       
    }
    
   

}

@end
