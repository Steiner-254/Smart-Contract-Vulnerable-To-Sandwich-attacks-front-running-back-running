// Improved Smart Contract
pragma solidity ^0.8.0;

contract ImprovedContract {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public pendingWithdrawals;
    uint256 public lastTokenPriceUpdate;
    uint256 public tokenPrice;

    constructor() {
        balances[msg.sender] = 1000;
        lastTokenPriceUpdate = block.timestamp;
        tokenPrice = 10; // Initialize with a default value
    }

    function buyTokens(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Calculate the cost based on the current token price
        uint256 cost = amount * tokenPrice;

        // Update the sender's pending withdrawal before transferring any funds
        pendingWithdrawals[msg.sender] += cost;

        // Deduct tokens from the sender's balance
        balances[msg.sender] -= amount;

        // Emit an event to notify the front-end of the user's action
        emit TokensPurchased(msg.sender, amount, cost);

        // Update the token price with a delay
        if (block.timestamp >= lastTokenPriceUpdate + 1 hours) {
            tokenPrice = getLatestTokenPrice();
            lastTokenPriceUpdate = block.timestamp;
        }
    }

    function withdraw() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No pending withdrawals");
        pendingWithdrawals[msg.sender] = 0;

        // Transfer Ether to the sender
        payable(msg.sender).transfer(amount);
    }

    function getLatestTokenPrice() internal view returns (uint256) {
        // In a real-world scenario, this function would fetch the latest token price from an external source
        // For the sake of this example, we'll return a hardcoded value.
        return 10; // 1 token costs 10 Wei
    }

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);
}
