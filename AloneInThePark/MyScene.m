//
//  MyScene.m
//  AloneInThePark
//
//  Created by Elton Mendes on 14/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "MyScene.h"
#import "Joystick.h"
#import "BoxSpriteNode.h"
#import "PlayerSpriteNode.h"
@implementation MyScene

Joystick *joystick;
SKSpriteNode *pad;
SKSpriteNode *backgroundScenario;
BoxSpriteNode *box1;
PlayerSpriteNode *player;
SKNode *world;
SKAction *spriteAnimation;

BOOL isJumping;
BOOL isGrounded;
BOOL isRunning;
static const uint32_t boxCategory     =  0x1 << 0;
static const uint32_t playerCategory  =  0x1 << 1;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        isGrounded = true;
        self.physicsWorld.contactDelegate = self;

        spriteAnimation = [self spriteAnimation];
        
        backgroundScenario = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        [backgroundScenario setPosition:CGPointMake(250, 300)];
        [backgroundScenario setScale:0.5];
        [self addChild:backgroundScenario];
        
        world = [[SKNode alloc]init];
        [self addChild:world];


        
        
        
        //Player
        
        player = [[PlayerSpriteNode alloc ]initWithTexture:[SKTexture textureWithImageNamed:@"player0.png"]];
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.collisionBitMask = playerCategory | boxCategory ;
        player.physicsBody.contactTestBitMask = playerCategory | boxCategory;
        [self addChild:player];
        
        [self addFloor];
        
        //Joystick
        
        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick.png"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
        joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        joystick.position = CGPointMake(30, 220);
        [self addChild:joystick];
        
        //Keypad
        
        pad = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton.png"];
        [pad setScale:0.1];
        pad.position = CGPointMake(270, 220);
        [self addChild:pad];
        
        //Box
        
        box1 = [[BoxSpriteNode alloc]initWithImageNamed:@"box.jpg"];
        box1.position = CGPointMake(180,220);
        [box1 setScale:0.1];
        box1.physicsBody.categoryBitMask = boxCategory;
        [world addChild:box1];
        
        


        
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for(UITouch *touch in touches){
        CGPoint touchLocation = [touch locationInNode:self];
        if(CGRectContainsPoint(pad.frame, touchLocation) && isGrounded){
            //isGrounded = false;
            CGPoint jumpPoint =  CGPointMake(player.position.x, player.position.y + 150);
            SKAction *jumpAction = [SKAction moveTo:jumpPoint duration:0.2];
            [player runAction:jumpAction completion:^{
                //[self performSelectorInBackground:@selector(setGrounded) withObject:NO];
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
        player.xScale = -0.5;
        
        [self worldMoveRight];
        [self backgroundParallaxMoveRight];
       
        if(!isRunning){
            [self movePlayerAnimating];
        }
       
    }
    else if (joystick.velocity.x < 0){
        player.xScale = 0.5;
      
        [self worldMoveRight];
        [self backgroundParallaxMoveLeft];
        
        if(!isRunning){
            [self movePlayerAnimating];
        }
    }
    
    [box1.particle setParticlePosition:box1.position];
    
}


#pragma physycs delegate

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if(contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == boxCategory){
        //Start fires at box when player touch box
        
        
        if(!box1.isDamaged){
            
            //Particle Scene
            
            NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"];
            SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
            [myParticle setScale:1];
            myParticle.particlePosition = CGPointMake(box1.position.x+50, box1.position.y);
            
            [world addChild:myParticle];
            [box1 setParticle:myParticle];
            [box1 setIsDamaged:YES];
        }
       
    }
}

#pragma scene configs and scenario
- (void)addFloor{
    //Floor
    
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.jpg"];
    floor.position = CGPointMake(100, 200);
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1024, 40)];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.affectedByGravity = false;
    
    [world addChild:floor];
    
    SKSpriteNode *floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floor.jpg"];
    floor2.position = CGPointMake(1300, 200);
    floor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1024, 40)];
    floor2.physicsBody.dynamic = NO;
    floor2.physicsBody.affectedByGravity = false;
    
    [world addChild:floor2];
}

#pragma worldMovement;

- (void)worldMoveRight{
    SKAction *sceneFollow = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 2), world.position.y) duration:0.1];
    [world runAction:sceneFollow];
}

- (void)worldMoveLeft{
    SKAction *sceneFollow = [SKAction moveTo:CGPointMake(world.position.x - (joystick.velocity.x * 2), world.position.y) duration:0.1];
    [world runAction:sceneFollow];
}

#pragma backgroundParallax;

- (void)backgroundParallaxMoveRight{
    SKAction *backgroundParallax = [SKAction moveTo:CGPointMake(backgroundScenario.position.x - (joystick.velocity.x * 0.1), backgroundScenario.position.y) duration:0.1];
    
    [backgroundScenario runAction:backgroundParallax];
}
- (void)backgroundParallaxMoveLeft{
    SKAction *backgroundParallax = [SKAction moveTo:CGPointMake(backgroundScenario.position.x - (joystick.velocity.x * 0.1), backgroundScenario.position.y) duration:0.1];
    
    [backgroundScenario runAction:backgroundParallax];
}

- (void) movePlayerAnimating{
    isRunning = true;
    [player runAction:spriteAnimation completion:^{
        [self performSelectorOnMainThread:@selector(removePlayerAnimation) withObject:NO waitUntilDone:NO];
        isRunning = false;
    }];
}

- (void)removePlayerAnimation{
    [player removeAllActions];
    [player setTexture:[SKTexture textureWithImageNamed:@"player0.png"]];
}

- (SKAction*)spriteAnimation{
    NSMutableArray *texturesArray = [[NSMutableArray alloc]init];

    for(int i =1;i<6;i++){
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"player%i.png",i]];
        [texturesArray addObject:texture];
    }
    return [SKAction animateWithTextures:texturesArray timePerFrame:0.1 resize:NO restore:YES];
}

@end
