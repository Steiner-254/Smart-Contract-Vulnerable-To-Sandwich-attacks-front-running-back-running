// Vulnerable Smart Contract
pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint256) public balances;

    constructor() {
        balances[msg.sender] = 1000;
    }

    function buyTokens(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        uint256 tokenPrice = getLatestTokenPrice(); // Function to get the current token price from an external source
        uint256 cost = amount * tokenPrice;

        // Deduct tokens from the sender's balance
        balances[msg.sender] -= amount;

        // Send tokens to the sender
        // Vulnerability: Reentrancy Attack
        (bool success, ) = msg.sender.call{value: cost}("");
        require(success, "Transfer failed");

        // Vulnerability: Front-running or Back-running may occur here
        // Because the token price can change between the previous step and this one
        // An attacker can manipulate the price to profit unfairly.
        balances[msg.sender] += amount;
    }

    function getLatestTokenPrice() internal view returns (uint256) {
        // In a real-world scenario, this function would fetch the latest token price from an external source
        // For the sake of this example, we'll return a hardcoded value.
        return 10; // 1 token costs 10 Wei
    }
}
