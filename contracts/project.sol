// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToolRental {
    struct Tool {
        uint256 id;
        address payable owner;
        string name;
        uint256 pricePerDay;
        bool isAvailable;
    }

    mapping(uint256 => Tool) public tools;
    uint256 public nextToolId;
    
    event ToolListed(uint256 id, address owner, string name, uint256 pricePerDay);
    event ToolRented(uint256 id, address renter, uint256 daysRented, uint256 totalPrice);

    function listTool(string memory name, uint256 pricePerDay) public {
        tools[nextToolId] = Tool(nextToolId, payable(msg.sender), name, pricePerDay, true);
        emit ToolListed(nextToolId, msg.sender, name, pricePerDay);
        nextToolId++;
    }

    function rentTool(uint256 toolId, uint256 daysRented) public payable {
        Tool storage tool = tools[toolId];
        require(tool.isAvailable, "Tool not available");
        uint256 totalPrice = tool.pricePerDay * daysRented;
        require(msg.value >= totalPrice, "Insufficient payment");

        tool.owner.transfer(msg.value);
        tool.isAvailable = false;
        
        emit ToolRented(toolId, msg.sender, daysRented, totalPrice);
    }
}
