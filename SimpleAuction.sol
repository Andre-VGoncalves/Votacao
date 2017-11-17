pragma solidity ^0.4.11;

contract SimpleAuction {
    address public beneficiary;
    uint public auctionEnd;

    address public highestBidder;
    uint highestBid;

    mapping (address => uint) pedingReturns;

    bool ended;

    event HighestBidIncreased (address bidder, uint amount);
    event AuctionEnded (address winner, uint amount);

    function SimpleAuction (
        uint _biddingTime,
        address _beneficiary
    ) {
        beneficiary = _beneficiary;
        auction = now + _biddingTime;
    }
}