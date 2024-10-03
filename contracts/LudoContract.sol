// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract LudoGame {
    uint public numberOfPlayer;

    uint private hasNotPlayed;

    uint256 dice1;
    uint256 dice2;

    uint constant tiles = 58;
    uint constant saveZone = 53;
    
    enum GameState { WaitingForPlayers, Ongoing, Finished }
    
    struct Player {
        uint piece1;
        uint piece2;
        uint piece3;
        uint piece4;
        uint pieceIsHome;
        bool isWinner;
    }

    GameState public gameState;
    

    // ARRAY OF PLAYERS
    address[] public Players;
    
    mapping(address => bool) private isPlayer;
    // checks if players peice has made it home
    mapping(address => mapping(uint => bool)) private isHome;
    // identifying each players piece
    mapping(address => Player) private playerPiece;

    // CUSTOM ERRORS
    error gameAlreadyStarted();
    error addressZeroDetected();
    error minNumberOfPlayer2();
    error maxPlayerReached();
    error alreadyAPlayer();
    error notAPlayer();
    error notYourTurn(); 
    error gameHasNotStarted();

    // EVENTS
    event RegistrationSuccessful(address indexed player);
    
    // CHECKER FUNCTIONS
    function onlyPlayer() view private {
        if(!isPlayer[msg.sender]) revert notAPlayer();
    }

    function checkForAddressZero() view private {
        if(msg.sender == address(0)) revert addressZeroDetected();
    }

    // function isPieceSave() pure private returns(bool pieceIsSave) {
    //     Player memory player = Player(0,0,0,0, 0, false );

    //     if(player.piece1 >= saveZone) pieceIsSave = true;
    // }
    
    function onlyCurrentPlayer() view private {
        if(Players[hasNotPlayed] != msg.sender) revert notYourTurn();
    }
    
    // IN GAME LOGIC CALCULATIONS
    function monitorBattleField() internal {

    }

    function movePiece(uint roll) internal {

    }

    // GAMING FUNCTIONS
    function registerMe() external {
        checkForAddressZero();
        if(isPlayer[msg.sender]) { revert alreadyAPlayer(); }
        if(numberOfPlayer == 4) { revert maxPlayerReached(); }


        isPlayer[msg.sender] = true;
        Players.push(msg.sender);

        Player memory player = Player(0,0,0,0, 0, false );
        playerPiece[msg.sender] = player;

        numberOfPlayer += 1;

        emit RegistrationSuccessful(msg.sender);
    }

    function registerPlayers(address _player) external {
        checkForAddressZero();
        if(_player == address(0)) { revert addressZeroDetected(); }
        if(isPlayer[_player]) { revert alreadyAPlayer(); }
        if(numberOfPlayer == 4) { revert maxPlayerReached(); }


        isPlayer[_player] = true;
        Players.push(_player);

        numberOfPlayer += 1;

        emit RegistrationSuccessful(_player);
    }

    function startGame() external {
        onlyPlayer();
        if(numberOfPlayer < 2) { revert minNumberOfPlayer2(); }
        if(gameState != GameState.WaitingForPlayers) { revert gameAlreadyStarted(); }
        gameState = GameState.Ongoing;
    }
    
    function rollDice() external  {
        onlyCurrentPlayer();
        if(gameState != GameState.Ongoing) { revert gameHasNotStarted(); }
        
        dice1 = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 6) + 1;
        dice2 = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 6) + 1;

        movePiece(dice1 + dice2);
        
        // Switch turn
        hasNotPlayed == (Players.length - 1) ? hasNotPlayed = 0 : hasNotPlayed += 1;
    }
    

    
}


// To implement the functionality for moving pieces and checking if they are home in the Ludo game contract, we can build on the existing structure. Here's a logical outline of how to approach this:

// ### 1. Define Piece Positions
// Each player will have pieces represented by their positions on the board. You could enhance the `Player` struct to include the current position of each piece. For example:
// ```solidity
// struct Player {
//     uint piece1; // position of piece 1
//     uint piece2; // position of piece 2
//     uint piece3; // position of piece 3
//     uint piece4; // position of piece 4
// }
// ```
// Each piece would start at position 0 (off the board) and can move to positions 1 through 58.

// ### 2. Move Logic
// In the `movePiece(uint roll)` function, the logic would need to:
// - Determine which piece the current player wants to move (you could require them to specify which piece they are moving).
// - Check if the move is valid:
//   - Ensure the piece can move the rolled number of spaces.
//   - Handle scenarios where a piece moves from off the board (needs a specific roll to enter).
//   - Consider landing on other players' pieces and if they can be sent back to start.

// - Update the piece’s position based on the roll and adjust the `isHome` mapping to reflect if a piece has reached the final position.

// ### 3. Check for Home
// After moving a piece, you would need to check if it has reached the home position (e.g., position 58). If it has:
// - Update the `isHome` mapping to indicate that the specific piece is home.
// - Optionally emit an event to notify that a piece has reached home.

// ### 4. Turn Management
// In the `rollDice()` function, after the roll and moving pieces, check if the game rules allow the current player to take another turn (e.g., if they rolled doubles, they may roll again). This logic can be integrated after the piece movement.

// ### 5. Game State Handling
// Ensure that any new functions respect the game state (`WaitingForPlayers`, `Ongoing`, and `Finished`). For instance:
// - Prevent moving pieces if the game has not started.
// - Handle conditions when all pieces are home, transitioning the game state to `Finished`.

// ### 6. User Input
// Consider how you would gather player input for which piece to move. This could involve adding additional parameters to the `rollDice()` or `movePiece()` functions to specify the piece index (1-4).

// ### Summary
// In summary, the logic for moving pieces should involve:
// - Structuring the player’s data to include piece positions.
// - Validating moves based on current game state and rules.
// - Updating positions and checking for "home" status after moves.
// - Ensuring that turn-taking is managed effectively throughout the game.

// By following these steps, you can build on the existing code base while ensuring the game mechanics align with typical Ludo rules.