// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Global {
    mapping(address => address[]) public campaignsByManager;
    mapping(address => address[]) public campaignsByContributor;

    function getCampaignsByManager(address _manager) public view returns (address[] memory) {
        return campaignsByManager[_manager];
    } 

    function getCampaignsByContributor(address _contributor) public view returns (address[] memory) {
        return campaignsByManager[_contributor];
    } 

}