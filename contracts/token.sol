// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract token is ERC20Capped, ERC20Burnable {

    address payable public owner;
    uint public blockReward;

    function _mint(address account, uint256 amount) internal virtual override(ERC20,ERC20Capped) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
    constructor(uint cap, uint reward) ERC20("OceanToken","OCT") ERC20Capped(cap *(10**decimals())) {
        owner=payable(msg.sender);
        _mint(owner, 70000000 * (10**decimals()));
        blockReward=reward* (10**decimals());
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase,blockReward);
    }
    function setReward(uint _reward) public onlyOwner{
        blockReward=_reward;
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0))
        { _mintMinerReward();
        }
        super._beforeTokenTransfer(from,to,amount);
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }
}

//mint 70000000 to owner
//set a cap for 100000000
//make it burnable
//blockreward
//destroy
//0xe0Ab4170d6CA8B529348E85f2251B46A7A1Bb87f
//https://goerli.etherscan.io/token/0xe0Ab4170d6CA8B529348E85f2251B46A7A1Bb87f