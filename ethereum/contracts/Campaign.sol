// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DeployedFactory {

}

contract Campaign {
    uint numRequests;
    mapping (uint => Request) requests;
    address public manager;
    address public globalManager;
    address public factory;
    string public description;
    uint public minimumContribution;
    mapping(address => bool) public backers;
    uint public backersCount;
    bool public isCensored;
    uint public reportCount;
    mapping(address => bool) private reporters;
    mapping(address => bool) public compensatedBackers;
    DeployedFactory df;

    enum Status {OPEN, CENSORED, DISSOLVED, FINISHED}
    status public campaignStatus;
    
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
        require(campaignStatus == status.OPEN);
        _;
    }

    constructor(uint _minimum, address _creator, address _globalManager, address _factory, string memory _description)  {
        manager = _creator;
        minimumContribution = _minimum;
        globalManager = _globalManager;
        factory = _factory;
        description = _description;
        campaignStatus = status.OPEN;
        isCensored = false;
    }

    function contribute() public payable validCampaign {
        require(msg.value > minimumContribution);

        backers[msg.sender] = true;
        backersCount++;

        // update campaignsByContributor mapping in factory
        campaignsByContributor[msg.sender].push(address(this));
        
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
        campaignStatus == status.CENSORED;
        isCensored = true;
    }

    function unCensorCampaign() public restrictedToGlobalManager {
        require(isCensored);
        campaignStatus == status.OPEN;
        isCensored = false;
    }

    function reportCampaign() public {
        require(!reporters[msg.sender]);
        reporters[msg.sender] = true;
        reportCount++;
    }

    // function voteToDissolveCampaign() public restrictedToBacker {}

    function initiateBankruptcy() public restrictedToManager {
        campaignStatus = status.DISSOLVED;
    }

    // function processBankruptcy() public restrictedToGlobalManager {
    //     require(campaignStatus == status.DISSOLVED);
    // }

    function getMoneyBack() public payable restrictedToBacker {
        require(!compensatedBackers[msg.sender]);
        require(campaignStatus == status.DISSOLVED);
        
        compensatedBackers[msg.sender] = true;
        payable(msg.sender).transfer(address(this).balance/backersCount);
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
