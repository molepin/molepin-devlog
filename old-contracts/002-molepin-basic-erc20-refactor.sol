// WARNING:
// Experimental MOLEPIN token contract.
// This version simplified the initial inheritance-heavy structure
// into a single ERC-20 style contract with owner controls,
// transfer lock, allowlist, blocklist, and burn logic.
// Archived for development history only.
// Do not use in production.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MOLEPIN {
    string public name = "MOLEPIN";
    string public symbol = "MOL";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    bool public transferLock;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public allowedAddress;
    mapping(address => bool) public blockedAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TokenBurn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier isTransferAllowed(address from, address to) {
        require(!blockedAddress[from] && !blockedAddress[to] && !blockedAddress[msg.sender], "Blocked address");
        require(allowedAddress[from] || !transferLock, "Transfers are locked");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalSupply = 6942151277013 * (10 ** decimals);
        balanceOf[owner] = totalSupply;
        allowedAddress[owner] = true;
    }

    // === ERC-20 Functions ===

    function transfer(address _to, uint256 _value) public isTransferAllowed(msg.sender, _to) returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public isTransferAllowed(_from, _to) returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not allowed");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // === Admin Functions ===

    function burn(uint256 _value) public onlyOwner returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit TokenBurn(msg.sender, _value);
        return true;
    }

    function addAllowedAddress(address _address) public onlyOwner {
        allowedAddress[_address] = true;
    }

    function removeAllowedAddress(address _address) public onlyOwner {
        require(_address != owner, "Owner cannot be removed");
        allowedAddress[_address] = false;
    }

    function addBlockedAddress(address _address) public onlyOwner {
        require(_address != owner, "Owner cannot be blocked");
        blockedAddress[_address] = true;
    }

    function removeBlockedAddress(address _address) public onlyOwner {
        blockedAddress[_address] = false;
    }

    function setTransferLock(bool _locked) public onlyOwner {
        transferLock = _locked;
    }

    // === Fallback ===

    fallback() external payable {
        revert("Unsupported function call");
    }

    receive() external payable {
        revert("ETH not accepted");
    }
}
