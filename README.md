2345

A game of Tic-tac-toe for Apple platforms. The game is written in Swift and makes use of SpriteKit and GameplayKit.

## Custom SKNodes

There are three main custom node types: `ButtonNode`, `GlyphNode`, `PositionNode`. 

The `ButtonNode` implements touch and click handling for iOS and macOS through a custom button. The button is drawn using an `SKShapeNode` as the background with a `SKLabelNode` on top. tvOS focus handling isn't supported on the button, but this could be added easily.

The `GlyphNode` is an `SKShapeNode` subclass that draws an X or O shape using a `CGPath`. This allows the shape to be filled and stroked indepenently, whereas a traditional `SKLabelNode` can only be filled.

A `PositionNode` is an `SKNode` subclass used to represent the game board. The main purpose is the serve as a placeholder for a piece on the gameboard. During gameplay, a `GlyphNode` will added as a child node when a move is made. The `PositionNode` also includes an optional label showing the game board location-- helpful for debugging.

## State Machines

There are two state machines that is built using GameplayKit, one for driving the scene transitions and the other for managing moves during game play. Of the two, the first is simpler.

The scene state machine manages transitions between the menu and gameplay states. Scene changes happen in response to button taps. On the menu scene, the user can transition to one player and two player game states. From the game scene, the user can only transition back to the menu scene. All of these transitions are managed by the scene state machine.

(AppDelegate should be implementing this, get ride of the scene manager)

The gameplay state machine manages the moves made during the course of the game. This includes making moves for player X and O, checking for wins, and deciding whose move is next. Two assumptions are made to make things easier: Player X always goes first and the computer always plays as O. Both of these could be changed.

Flow of gameplay state machine:

Select Player -> Player X -> Check Win -> Select Player -> Player O -> Check Win -> ... -> Win/Draw

The gameplay state machine in particular helps to hide the details of gameplay, by pulling the implementation out of the `GameScene` and placing it in the individual state. This leaves the game scene responsible for setting up the UI, initiating the statemachine, and then adding/removing pieces in response to state changes.

## Adding Actions

`SKActions` allow nodes to be animated. The current animations in the game are pretty simple.

1. When a button is tapped, it appears in pressed in and bounce back. The buttons are `SKNodes` underneath which allows `SKActions` to be added onto them. 
2. When a player wins, the winning pieces are given a wiggle animation. This is perform by creating `SKActions` to repeatedly scale the node in the X and Y directions.
3. When the game board resets, all pieces on the board quickly drop off the screen. This is done using a physics body and applying a force to each node.

## Scoring

Through GameplayKit, `GKMinmaxStrategist` is used for opponent play. The first requires game play be model according to three protocols: `GKGameModel`, `GKGameModelPlayer`, and `GKGameModelUpdate`. Implementing a game according to this protocol always GameplayKit to play the game as an opponent. Still required to implement scoring.

Scoring requires list of winning combinations. For each combination, the piece on the board are examined to see if the fit differnet criteria. This includes how many pieces are in a row and how many empty positions there are.

There are many options for scoring. As general rules, favor the middle position, then the corners, and avoid three in a row by opponents.

## Where can this go?

Multipeer, local gameplay against nearby peers.
GameKit games, over the net play with random peers.

Settings: color scheme, different glyphs for pieces.
High scores through CloudKit
easy, med, hard settings for the AI.

Show hint

## What are some CSee concepts used, or SpriteKit ideas.

AnchorPoint
Row major ordering for 2d array
Finite State Machines
Minmax Search Algorithm

## As a playground, topics included.

1. Create the board in screen. Little bit of math for board size to piece size. Create one screen, anchor to center, add board.
2. Create a `SKLabelNode`, style like a piece. Add the piece to the board.
3. Add position nodes, initially as red boxes. 9 position nodes should be added directly on top of the board. Figure out math for positioning pieces. Walk through algo with hard coded points.
4. Add touch/click handling to the position node. Change color or do something in response to tap.
5. Work out coordinate system for virtual game board vs on screen spritekit game board. Figure out how to map between them.
6. Check for wins by using different tactics, e.g. walking board, magic squares.
7. Model game using GameplayKit protocols.
8. Build state machine for transitioning between gameplay states.
9. Minxmax and game scoring

 