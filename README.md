# TicTacToe

![Swift 4.0](https://img.shields.io/badge/swift-4.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-blue.svg)
[![license MIT](https://img.shields.io/badge/license-MIT-lightgray.svg)](http://opensource.org/licenses/MIT)

Tic-tac-toe for Apple platforms. Written in Swift with SpriteKit and GameplayKit.

## Requirements

* Xcode 10.2
* Swift 5

## Setup

Clone the repo and open the project in Xcode.

## Design

The game is designed to run on iOS, tvOS, and macOS by using a shared codebase for the core logic and SpriteKit for the gameplay and mechanics. The platform specific pieces are written using UIKit and AppKit.

The game logic centers are three distinct types. A `TTTPiece` is an `enum` with two possible states, X and O. A `TTTPosition` is either empty or contains an associated piece. A `TTTBoard` is composed of 9 position, all initially empty. As the game played, the empty positions on the board are filled with pieces until one player wins or the game ends in draw.

Building on top of the core types, the game play model is defined using `GameplayKit`. This includes defining a player, what the game model looks like, and how the model changes using gameplay. The `GKGameModelPlayer`, `GKGameModel`, and `GKGameModelUpdate` protocols are all conformed to by various classes in order to model the game.

There are two state machines there are built using GameplayKit. The scene state machine manages transitions between the menu and gameplay states. The gameplay state machine manages the moves made during the course of the game. This includes making moves for player X and O, checking for wins, and deciding whose move is next.

## Screenshot

![screenshot](http://i.imgur.com/g62uMtw.gif)
 