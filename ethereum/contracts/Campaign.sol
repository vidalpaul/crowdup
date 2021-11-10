// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Campaign {
    uint numRequests;
    mapping (uint => Request) requests;
    
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        bool cancelled;
        uint votes;
        uint approvalCount;
        mapping(address => bool) approvals;
        uint rejectionsCount;
        mapping(address => bool) rejections;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public backers;
    uint public backersCount;
    bool public isCensored;
    uint public reportCount;
    mapping(address => bool) private reporters;

    enum status {OPEN, CENSORED, DISSOLVED, FINISHED}
    status public campaignStatus;

    modifier restrictedToManager() {
        require(msg.sender == manager);
        _;
    }

    modifier restrictedToBacker() {
        require(backers[msg.sender]);
        _;
    }

    modifier restrictedToGlobalManager() {
        require(msg.sender == globalManager);
        _;
    }

    modifier validCampaign() {
        require(campaignStatus == OPEN);
        _;
    }

    constructor(uint _minimum, address _creator, address _globalManager, address _factory)  {
        manager = _creator;
        minimumContribution = _minimum;
        globalManager = _globalManager;
        factory = _factory;
        campaignStatus = OPEN;
    }

    function contribute() public payable validCampaign {
        require(msg.value > minimumContribution);

        backers[msg.sender] = true;
        backersCount++;

        // update mapping
    }

    function createRequest(string calldata _description, uint _value, address payable _recipient) public restrictedToManager validCampaign {
        Request storage r = requests[numRequests++];
        r.description = _description;
        r.value = _value;
        r.recipient = _recipient;
        r.complete = false;
        r.approvalCount = 0;
    }

    function approveRequest(uint index) public restrictedToBacker validCampaign {
        Request storage request = requests[index];

        require(backers[msg.sender]);
        require(!request.approvals[msg.sender]);
        require(!request.rejections[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
        request.votes++;
    }

    function rejectRequest(uint index) public restrictedToBacker validCampaign {
        Request storage request = requests[index];

        require(backers[msg.sender]);
        require(!request.approvals[msg.sender]);
        require(!request.rejections[msg.sender]);

        request.rejections[msg.sender] = true;
        request.rejectionsCount++;
        request.votes++;
    }

    function finalizeRequest(uint idx) public restrictedToManager validCampaign {
        Request storage request = requests[idx];

        require(request.approvalCount > (backersCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    // still to do
    function cancelRequest(uint idx) public restrictedToManager validCampaign {
        Request storage request = requests[idx];
        request.cancelled = true;
    }

    function censorCampaign() public restrictedToGlobalManager {
        require(!isCensored);
        isCensored = true;
    }

    function unCensorCampaign() public restrictedToGlobalManager {
        require(isCensored);
        isCensored = false;
    }

    function reportCampaign() public {
        require(!reporters[msg.sender]);
        reporters[msg.sender] = true;
        reportCount++;
    }

    function voteToDissolveCampaign() public restrictedToBacker {}

    function initiateBankruptcy() public restrictedToManager {}

    function processBankruptcy() public restrictedToGlobalManager {}

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