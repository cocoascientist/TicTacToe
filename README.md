# TicTacToe

![Swift 3.0](https://img.shields.io/badge/swift-3.2-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-blue.svg)
[![license MIT](https://img.shields.io/cocoapods/l/GROCloudStore.svg)](http://opensource.org/licenses/MIT)

Tic-tac-toe for Apple platforms. written in Swift and makes use of SpriteKit and GameplayKit.

## Requirements

* Xcode 8.3
* Swift 3.2

## Setup

Clone the repo and open the project in Xcode.

## Design

## Screenshot

![screenshot](http://i.imgur.com/g62uMtw.gif)

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


 