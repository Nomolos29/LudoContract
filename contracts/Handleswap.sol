// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
import "./interfaces/IUniswapV2Router.sol";
import "./interfaces/IERC20.sol";
import "hardhat/console.sol";

// UseSwap contract for handling token swaps
contract UseSwap {

  // Address of the Uniswap router
  address public uniswapRouter;
  // Owner of the contract
  address public owner;
  // Count of successful swaps
  uint public swapCount;

  // Constructor to initialize the Uniswap router and owner
  constructor(address _uniswapRouter) {
      uniswapRouter = _uniswapRouter;
      owner = msg.sender;
  }


  // Function to handle token swaps for ETH
  function handleSwapTokensForExactETH(
      uint amountOut,
      uint amountInMax,
      address[] calldata path,
      address to,
      uint deadline
  ) external {

      // Transfer tokens from the sender to the contract
      IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax);

      // Approve the Uniswap router to spend the tokens
      require(IERC20(path[0]).approve(uniswapRouter, amountInMax), "approve failed.");
      
      // Swap tokens for ETH using the Uniswap router
      IUniswapV2Router(uniswapRouter).swapTokensForExactETH(
          amountOut,
          amountInMax,
          path,
          to,
          deadline
      );

      // Increment the swap count
      swapCount += 1;
  }

  function handleSwapExactTokensForETH(
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
    address TOKEN_ADDRESS
  ) external payable {
    // Approve the Uniswap router to spend the tokens
    require(IERC20(TOKEN_ADDRESS).approve(uniswapRouter, msg.value), "approve failed.");
    require(amountOutMin > 0, "ETH amount must be greater than 0.");
    require(path.length >= 1, "Path must have at least 2 addresses.");

    
    IUniswapV2Router(uniswapRouter).swapExactTokensForETH(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    );

    swapCount += 1;
}

  // Function to remove liquidity
  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline,
    address TOKEN_ADDRESS
  ) external {
      
    IERC20(TOKEN_ADDRESS).transferFrom(msg.sender, address(this), liquidity);

    require(IERC20(TOKEN_ADDRESS).approve(uniswapRouter, liquidity), "Transfer failed");

    IUniswapV2Router(uniswapRouter).removeLiquidity(
        tokenA,
        tokenB,
        liquidity,
        amountAMin,
        amountBMin,
        to,
        deadline
    );

    swapCount += 1;
  }

}