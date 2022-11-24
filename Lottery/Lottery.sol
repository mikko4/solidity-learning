// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

contract Lottery {
    address public owner;
    address payable[] public contestants;

    constructor() {
        owner = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == owner);
        _;
    }

    function enter() public payable {
        require(msg.value >= 0.01 ether);

        contestants.push(payable(msg.sender));
    }

    function random() private view returns (uint) {
        bytes memory hash = abi.encode(block.difficulty, block.timestamp, contestants);
        return uint(keccak256(hash));
    }

    function selectWinner() public payable restricted {
        uint index = random() % contestants.length;
        contestants[index].transfer(address(this).balance);
        contestants = new address payable[](0);
    }

    function getPrizePool() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view restricted returns (address payable[] memory) {
        return contestants;
    }
}