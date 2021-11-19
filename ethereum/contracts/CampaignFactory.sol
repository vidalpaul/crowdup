// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './Campaign.sol';

contract CampaignFactory {
    mapping(address => address[]) public campaignsByManager;
    mapping(address => address[]) public campaignsByContributor;
    mapping(address => bool) public blockedAddresses;
    address public siteManager;
    address[] public deployedCampaigns;

    enum blockAccountReasons {REPORTED_BY_COMMUNITY, JUDICIAL, UNSUCCESSFUL}

    constructor() {
        // siteManager account can block Ethereum addresses, dissolve campaigns
        siteManager == msg.sender;
    }

    modifier restrictedToSiteManager() {
        require(msg.sender == siteManager);
        _;
    }
    
    function createCampaign(uint minimum, string description) public {
        // require msg.sender is not blocked account
        require(!blockedAddresses[msg.sender]);
        address newCampaign = address(new Campaign(minimum, msg.sender, siteManager, address(this)));
        deployedCampaigns.push(newCampaign);
        campaignsByManager[msg.sender].push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }

      function getCampaignsByManager(address _manager) public view returns (address[] memory) {
        return campaignsByManager[_manager];
    } 

    function getCampaignsByContributor(address _contributor) public view returns (address[] memory) {
        return campaignsByManager[_contributor];
    } 

    function isBlockedAddress(address _address) public view returns (bool) {
        return blockedAddresses[_address];
    }

    function blockAddress(address _address) restrictedToSiteManager public {
        blockedAddresses[_address] = true;
    }

    function updateCampaignsByContributor(address _contributor, address _campaign) public {
        // an array in this case is actually ok
        require(!campaingsByContributor[_contributor]);
    }

}