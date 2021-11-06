// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract CampaignFactory {
    address[] public deployedCampaigns;

    constructor() {
        censor == msg.sender;
    }
    
    function createCampaign(uint minimum) public {
        address newCampaign = address(new Campaign(minimum, msg.sender, censor));
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}


contract Campaign {
    uint numRequests;
    mapping (uint => Request) requests;
    
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint votes;
        uint approvalCount;
        mapping(address => bool) approvals;
        uint rejectionsCount;
        mapping(addres => bool) rejections;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public backers;
    uint public backersCount;

    modifier restrictedToManager() {
        require(msg.sender == manager);
        _;
    }

    modifier restrictedToBacker() {
        require(backers[msg.sender]);
        _;
    }

    modifier restrictedToCensor() {
        require(msg.sender == censor);
        _;
    }

    constructor(uint _minimum, address _creator, address _censor)  {
        manager = _creator;
        minimumContribution = _minimum;
        censor = _censor;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        backers[msg.sender] = true;
        backersCount++;
    }

    function createRequest(string calldata _description, uint _value, address payable _recipient) public restrictedToManager {
        Request storage r = requests[numRequests++];
        r.description = _description;
        r.value = _value;
        r.recipient = _recipient;
        r.complete = false;
        r.approvalCount = 0;
    }

    function approveRequest(uint index) public restrictedToBacker {
        Request storage request = requests[index];

        require(backers[msg.sender]);
        require(!request.approvals[msg.sender]);
        require(!request.rejections[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
        request.votes++;
    }

    function rejectRequest(uint index) public restrictedToBacker {
        Request storage request = requests[index];

        require(backers[msg.sender]);
        require(!request.approvals[msg.sender]);
        require(!request.rejections[msg.sender]);

        request.rejections[msg.sender] = true;
        request.rejectionsCount++;
        request.votes++;
    }

    function finalizeRequest(uint index) public restrictedToManager {
        Request storage request = requests[index];

        require(request.approvalCount > (backersCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (uint, uint, uint, uint, address) {
        return (
            minimumContribution, 
            address(this).balance, 
            numRequests, 
            backersCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return numRequests;
    }
}