// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
interface ImyERC20 {
    function balanceOf(address owner) public returns (uint256);
    function transfer(address to, uint256 amount) public returns (bool);
    function decimals() public returns (uint256);
}

contract TokenSale {
    ImyERC20 public tokenContract;  // the token being sold
    uint256 public price;              // the price, in wei, per token
    address owner;

    uint256 public tokensSold;

    event Sold(address buyer, uint256 amount);

    function purchase(ImyERC20 _tokenContract, uint256 _price) public {
        owner = msg.sender;
        tokenContract = _tokenContract;
        price = _price;
    }

    function buyTokens(uint256 numberOfTokens) public payable {
        require(msg.value == safeMultiply(numberOfTokens, price));

        uint256 scaledAmount = safeMultiply(numberOfTokens,
            uint256(10) ** tokenContract.decimals());

        require(tokenContract.balanceOf(this) >= scaledAmount);

        emit Sold(msg.sender, numberOfTokens);
        tokensSold += numberOfTokens;

        require(tokenContract.transfer(msg.sender, scaledAmount));
    }

    function endSale() public {
        require(msg.sender == owner);

        // Send unsold tokens to the owner.
        require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));

        msg.sender.transfer(address(this).balance);
    }
}