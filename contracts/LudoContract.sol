// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract LudoGame {
    address public player1;
    address public player2;
    address public currentPlayer;
    
    enum GameState { WaitingForPlayers, Ongoing, Finished }
    GameState public gameState;
    
    uint8[4] public player1Positions;
    uint8[4] public player2Positions; 
    
    constructor(address _player2) {
        player1 = msg.sender;
        player2 = _player2;
        currentPlayer = player1;
        gameState = GameState.WaitingForPlayers;
    }

    // CUSTOM ERRORS
    error gameAlreadyStarted();
    error notAPlayer();
    error notYourTurn();
    error gameIsNotOngoing();
    
    // CHECKER FUNCTIONS
    function onlyPlayer() view private {
        if(msg.sender != player1 || msg.sender != player2) { revert notAPlayer(); }
    }
    
    function onlyCurrentPlayer() view private {
        if(msg.sender != currentPlayer) { revert notYourTurn(); }
    }
    
    function startGame() external {
        onlyPlayer();
        if(gameState != GameState.WaitingForPlayers) { revert gameAlreadyStarted(); }
        gameState = GameState.Ongoing;
    }
    
    function rollDice() external  {
        onlyCurrentPlayer();
        if(gameState != GameState.Ongoing) { revert gameIsNotOngoing(); }
        
        uint256 roll = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 6) + 1;
        movePiece(roll);
        
        // Switch turn
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
    }
    
    function movePiece(uint256 roll) internal {
        uint8 positionIndex = 0;
        if (currentPlayer == player1) {
            player1Positions[positionIndex] += uint8(roll);
        } else {
            player2Positions[positionIndex] += uint8(roll);
        }
    }
    
    function getPositions() external view returns (uint8[4] memory, uint8[4] memory) {
        return (player1Positions, player2Positions);
    }
    
}
