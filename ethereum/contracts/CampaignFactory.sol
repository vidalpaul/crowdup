// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './Campaign.sol';

contract CampaignFactory {
    address[] public deployedCampaigns;
    mapping(address => address[]) public campaignsByManager;
    mapping(address => address[]) public campaignsByContributor;

    constructor() {
        censor == msg.sender;
    }
    
    function createCampaign(uint minimum) public {
        address newCampaign = address(new Campaign(minimum, msg.sender, censor, address(this)));
        deployedCampaigns.push(newCampaign);
        campaignsByManager[msg.sender].push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }

    function getDeployedCampaignsByManager() public view returns (address[] memory) {
        return campaignsByManager[msg.sender];
    }

    function getCampaignsContributed() public view returns (address[] memory) {}
}