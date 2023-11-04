// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CustomToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balanceOf;

    uint256 public flatRateFee = 24e15; // 0.024 tokens (assuming the token has 18 decimals)

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = 18; // Assuming 18 decimals
        totalSupply = initialSupply * 10**uint256(decimals); // Set the initial supply
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        uint256 totalAmount = value + flatRateFee;
        require(
            balanceOf[msg.sender] >= totalAmount,
            "Insufficient balance to cover the transfer and fee"
        );

        balanceOf[msg.sender] -= totalAmount;
        balanceOf[to] += value;
        balanceOf[owner] += flatRateFee;
        emit Transfer(msg.sender, to, value);
        emit Transfer(msg.sender, owner, flatRateFee);

        return true;
    }

    function setFlatRateFee(uint256 newFee) public {
        require(msg.sender == owner, "Only the owner can set the flat rate fee");
        flatRateFee = newFee;
    }
}
