// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Global {
    mapping(address => address[]) public campaignsByManager;
    mapping(address => address[]) public campaignsByContributor;
    mapping(address => bool) public blockedAddresses;
    address public siteManager;

    enum blockAccountReasons {}

    constructor() {
        siteManager = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == siteManager);
        _;
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

    function blockAddress(address _address) public {
        blockedAddresses[_address] = true;
    }
}