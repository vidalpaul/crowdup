// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Global {
    mapping(address => address[]) public campaignsByManager;
    mapping(address => address[]) public campaignsByContributor;
}