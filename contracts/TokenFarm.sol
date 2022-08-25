// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./MoodToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Mood Token Farm";
    MoodToken public moodToken;
    DaiToken public daiToken;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public currentStakingStatus;
    address[] public stakers;

    constructor(MoodToken _moodToken, DaiToken _daiToken){
        moodToken = _moodToken;
        daiToken = _daiToken;
    }

    function stakeTokens(uint _amount) public {
        require(_amount > 0, "ammount must be greater than 0");
        daiToken.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] += _amount;
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);   
        }
        hasStaked[msg.sender] = true;
        currentStakingStatus[msg.sender] = true;
    }

    function unstakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking balance cannot be 0");
        daiToken.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;
        currentStakingStatus[msg.sender] = false;
    }


    function issueTokens() public {
        for (uint i=0; i<stakers.length; i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0){
                moodToken.transfer(recipient, balance);
            }
        }
    }
}