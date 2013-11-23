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
#import "FloorButtonSpriteNode.h"
#import "GameOverController.h"

@interface MyScene ()
@property (nonatomic, strong) Joystick *joystick;
@property (nonatomic, strong) SKSpriteNode *pad;
@property (nonatomic, strong) SKSpriteNode *backgroundScenario;
@property (nonatomic, strong) SKSpriteNode *bridge;
@property (nonatomic, strong) FloorButtonSpriteNode *floorButton;
@property (nonatomic, strong) BoxSpriteNode *box1;
@property (nonatomic, strong) PlayerSpriteNode *player;
@property (nonatomic, strong) SKNode *world;
@property (nonatomic, getter = isJumping) BOOL jumping;
@property (nonatomic, getter = isGrounded) BOOL grounded;
@property (nonatomic, getter = isRunning) BOOL running;
@property (nonatomic, getter = isGameOver) BOOL gameOver;
@end

@implementation MyScene

static const uint32_t boxCategory         =  0x1 << 0;
static const uint32_t floorButtonCategory =  0x1 << 1;
static const uint32_t playerCategory      =  0x1 << 2;
static const uint32_t castleCategory      =  0x1 << 3;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.grounded = true;
        self.physicsWorld.contactDelegate = self;
        [self.physicsWorld setGravity:CGVectorMake(0, -5)];
        self.backgroundScenario = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        [self.backgroundScenario setPosition:CGPointMake(250, 120)];
        [self.backgroundScenario setScale:0.6];
        [self addChild:self.backgroundScenario];
        
        self.world = [SKNode new];
        [self addChild:self.world];


        //Player
        
        self.player = [[PlayerSpriteNode alloc ]initWithTexture:[SKTexture textureWithImageNamed:@"player0.png"]];
        self.player.position = CGPointMake(120,20);
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = playerCategory | boxCategory ;
        self.player.physicsBody.contactTestBitMask = playerCategory | boxCategory;
        [self addChild:self.player];
        
        [self addFloor];
        
        //Joystick
        
        SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick.png"];
        SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
        self.joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
        self.joystick.position = CGPointMake(40, 40);
        [self addChild:self.joystick];
        
        //Keypad
        
        self.pad = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton.png"];
        [self.pad setScale:0.1];
        self.pad.position = CGPointMake(470, 40);
        [self addChild:self.pad];
        
        //Box
        
        self.box1 = [[BoxSpriteNode alloc]initWithImageNamed:@"box.jpg"];
        self.box1.position = CGPointMake(180,20);
        [self.box1 setScale:0.1];
        self.box1.physicsBody.categoryBitMask = boxCategory;
        self.box1.physicsBody.collisionBitMask = boxCategory | playerCategory | floorButtonCategory;
        self.box1.physicsBody.contactTestBitMask = boxCategory | playerCategory | floorButtonCategory;
        [self.world addChild:self.box1];
        
        //Castle
        
        SKSpriteNode *castle = [SKSpriteNode spriteNodeWithImageNamed:@"CastleSprit.jpg"];
        castle.position = CGPointMake(-300,150);
        [castle setScale:0.6];
        castle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(castle.frame.size.width, castle.frame.size.height)];
        castle.physicsBody.dynamic = NO;
        castle.physicsBody.affectedByGravity = false;
        [self.world addChild:castle];
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
        if(CGRectContainsPoint(self.pad.frame, touchLocation) && self.isGrounded){
            self.grounded = false;
            CGPoint jumpPoint =  CGPointMake(self.player.position.x, self.player.position.y + 50);
            SKAction *jumpAction = [SKAction moveTo:jumpPoint duration:0.2];

            [self.player runAction:jumpAction completion:^{
                [self performSelectorInBackground:@selector(setGrounded) withObject:NO];
            }];
            [self.player runAction:self.player.spriteJumpAnimation completion:^{
                
            }];
        }
    }
}


-(void) setGrounded{
   
    [NSThread sleepForTimeInterval:0.3];
    self.grounded = true;

}

- (void)showGameOver{
    GameOverController *gameOverController = [[GameOverController alloc]initWithTexture:[SKTexture textureWithImageNamed:@"gameOver.jpg"]];
   
    [gameOverController setPosition:CGPointMake(280, 160)];
    [self addChild:gameOverController];

}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //Ground Position:
   
    
    if(self.player.position.y <=0){
        if(!self.isGameOver){
            [self showGameOver];
            self.gameOver = true;
        }

    }
    
    
    //Right
    if(self.joystick.velocity.x > 0){
        self.player.xScale = -0.5;
        
        [self worldMove];
        [self backgroundParallaxMove];
       
        if(!self.isRunning){
            [self movePlayerAnimating];
        }
       
    }
    //Left - Screen Limit
    else if (self.joystick.velocity.x < 0 && self.world.position.x <=320){
        self.player.xScale = 0.5;
      
        [self worldMove];
        [self backgroundParallaxMove];
        
        if(!self.isRunning){
            [self movePlayerAnimating];
        }
    }
    
    [self.box1.particle setParticlePosition:self.box1.position];
    
}


#pragma physycs delegate


-(void)didBeginContact:(SKPhysicsContact *)contact{
    if(contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == boxCategory){
        //Start fires at box when player touch box
        
        
        if(!self.box1.isDamaged){
            
            //Particle Scene
            
            NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"];
            SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
            [myParticle setScale:1];
            myParticle.particlePosition = CGPointMake(self.box1.position.x+50, self.box1.position.y);
            
            [self.world addChild:myParticle];
            [self.box1 setParticle:myParticle];
            [self.box1 setIsDamaged:YES];
        }
       
    }
    if(contact.bodyA.categoryBitMask == floorButtonCategory && contact.bodyB.categoryBitMask == boxCategory){
        if(!self.floorButton.isPressed){
            SKAction *buttonPressed = [SKAction moveToY:self.floorButton.position.y-10 duration:0.2];
            [self.floorButton runAction:buttonPressed];
            self.floorButton.isPressed = true;
            NSLog(@"run action");
            SKAction *rotateBridge = [SKAction rotateToAngle:(M_PI / 2) duration:0.5];
            SKAction *moveBridge = [SKAction moveToX:self.bridge.position.x - 90 duration:0.5];
            SKAction *moveBridgey = [SKAction moveToY:self.bridge.position.y - 85 duration:0.5];
            [self.bridge runAction:rotateBridge completion:^{
                [self.box1 removeCollision];

            }];
            [self.bridge runAction:moveBridge];
            [self.bridge runAction:moveBridgey];
        }
  
    }
}

#pragma scene configs and scenario
- (void)addFloor{
    //Floor
    

    self.floorButton = [[FloorButtonSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"FloorButton.png"]];
    self.floorButton.physicsBody.categoryBitMask = floorButtonCategory;
    self.floorButton.isPressed = false;
    [self.world addChild:self.floorButton];
    
    self.bridge = [SKSpriteNode spriteNodeWithImageNamed:@"bridge.jpg"];
    [self.bridge setScale:0.3];
    self.bridge.position = CGPointMake(790, 100);
    self.bridge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.bridge.frame.size.width, self.bridge.frame.size.height)];
    self.bridge.physicsBody.dynamic = NO;
    self.bridge.physicsBody.affectedByGravity = false;
    [self.world addChild:self.bridge];
    
    
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:@"floor.jpg"];
    floor.position = CGPointMake(100, 0);
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1024, 40)];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.affectedByGravity = false;
    [self.world addChild:floor];
    
    SKSpriteNode *floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floor.jpg"];
    floor2.position = CGPointMake(1300, 0);
    floor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1024, 40)];
    floor2.physicsBody.dynamic = NO;
    floor2.physicsBody.affectedByGravity = false;
    
    [self.world addChild:floor2];
}

#pragma worldMovement;

- (void)worldMove{
    SKAction *sceneFollow = [SKAction moveTo:CGPointMake(self.world.position.x - (self.joystick.velocity.x * 2), self.world.position.y) duration:0.1];
    [self.world runAction:sceneFollow];
}

#pragma backgroundParallax;

- (void)backgroundParallaxMove{
    SKAction *backgroundParallax = [SKAction moveTo:CGPointMake(self.backgroundScenario.position.x - (self.joystick.velocity.x * 0.05), self.backgroundScenario.position.y) duration:0.1];
    
    [self.backgroundScenario runAction:backgroundParallax];
}


- (void) movePlayerAnimating{
    self.running = true;
    [self.player runAction:self.player.spriteWalkAnimation completion:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.player removePlayerAnimation];
        }];
        self.running = false;
    }];
}




@end
