// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './Campaign.sol';

contract CampaignFactory {
    address[] public deployedCampaigns;

    constructor() {
        censor == msg.sender;
    }
    
    function createCampaign(uint minimum) public {
        address newCampaign = address(new Campaign(minimum, msg.sender, censor, address(this)));
        deployedCampaigns.push(newCampaign);
        campaignsByManager[msg.sender].push(newCampaign);
        // todo: update campaignsByManager mapping in Global.sol
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }

}