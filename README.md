# Smart-Contract-Vulnerable-To-Sandwich-attacks-front-running-back-running
Smart Contract Vulnerable To Sandwich attacks (front-running/back-running)

# Description
~ A sandwich attack is a type of front-running or back-running attack that targets vulnerable smart contracts on blockchain platforms. These attacks typically involve manipulating the order of transactions to profit from price changes or take advantage of predictable behavior in the smart contract.

# vulnerable.sol
~ In this vulnerable.sol, the buyTokens function allows users to purchase tokens by sending Ether to the contract. However, it's vulnerable to sandwich attacks for the following reasons:

1. Reentrancy Attack Vulnerability: The contract uses the call function to transfer Ether to the sender. This can be exploited by a malicious contract calling buyTokens and then re-entering it before the state is updated. This can lead to an attacker draining the contract's balance.

2. Front-running/Back-running Vulnerability: The price of the token is obtained from an external source, and there is a delay between fetching the price and updating the user's balance. During this time, an attacker can observe the transaction and manipulate the token price to their advantage. They can either front-run (execute a transaction with a higher price before the victim) or back-run (execute a transaction with a lower price after the victim).

# fix.sol
~ In this improved contract:

1. We use the "Checks-Effects-Interactions" pattern to ensure that all state changes are made before interacting with other contracts or transferring Ether.

2. We add a pendingWithdrawals mapping to keep track of the Ether that users are entitled to withdraw. The Ether is only transferred to users when they explicitly request it using the withdraw function.

3. We introduce a delay mechanism for updating the token price. The contract only updates the token price once every hour (you can adjust the duration as needed). This minimizes the opportunity for front-running and back-running attacks.

4. We emit an event when tokens are purchased to notify the front-end about the transaction.
