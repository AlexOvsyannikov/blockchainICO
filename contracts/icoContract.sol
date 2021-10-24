pragma solidity ^0.5.16;

import "./tokenForIco.sol";

contract icoContract {
    uint256 public icoStartTime;
    uint256 public icoEndTime;
    tokenForIco public token;
    address public tokenAddress;
    uint256 public fundingGoal;
    address payable public owner;
    uint256 soldTokens = 0;
    using SafeMath for uint256;

    event TokenPurchase(address indexed receiver, uint256 amount);


    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function buy() public payable{
        require(now < icoEndTime && now > icoStartTime, "ICO not started or finished");
        require(soldTokens < fundingGoal, "ICO goal reached");
        uint256 tokensToBuy;
        uint256 weiUsed = msg.value;
        tokensToBuy = weiUsed.mul(287000);
        require(tokensToBuy <= token.balanceOf(tokenAddress), "Not enough tokens");

        token.buyTokens(msg.sender, tokensToBuy);
        soldTokens.add(tokensToBuy);
        emit TokenPurchase(msg.sender, tokensToBuy);
    }

    constructor(address _tokenAddress) public {
        require(_tokenAddress != address(0), "constructor off");
        icoStartTime = 1634893200;
        icoEndTime = 1634936340;
        tokenAddress = _tokenAddress;
        fundingGoal = 40000000 * 10e18;
        owner = msg.sender;
        token = tokenForIco(tokenAddress);
    }

    function extractEther() public onlyOwner {
        owner.transfer(address(this).balance);
   }

   function () external payable {
        buy();
    }


}
