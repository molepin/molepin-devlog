// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Variable
{
	string public name;
	string public symbol;
	uint256 public decimals;
	uint256 public totalSupply;
	address public owner;

	uint256 internal _decimals;
	bool internal transferLock;
	
	mapping (address => bool) public allowedAddress;
	mapping (address => bool) public blockedAddress;

	mapping (address => uint256) public balanceOf;
	
	mapping (address => mapping (address => uint256)) internal allowed;

	//constructor() public //0.8 에러는 constructor의 가시성은 무시, abstract 를 선업하거나 혹은 public 을 지오고 deploy 해야 만일 abstract를 선언하면 배포는 안됨

	constructor()
	{
		//name = "Social Master & Branch Swap";
		name = "MOLEPIN";
		symbol = "MOL";
		decimals = 18;
		_decimals = 10 ** uint256(decimals);
		totalSupply = _decimals * 6942151277013;
		transferLock = false;
		owner =	msg.sender;
		balanceOf[owner] = totalSupply;
		allowedAddress[owner] = true;
	}
}
contract Modifiers is Variable
{
	modifier isOwner
	{
		assert(owner == msg.sender);
		_;
	}
}
contract Event
{
	event Transfer(address indexed from, address indexed to, uint256 value);
	event TokenBurn(address indexed from, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}
contract Admin is Variable, Modifiers, Event
{
	using SafeMath for uint256;
	
	function tokenBurn(uint256 _value) public isOwner returns(bool success)
	{
		require(balanceOf[msg.sender] >= _value, "Invalid balance");

		//balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); // 소각할 수량만큼 사용자 잔액 감소
		totalSupply = totalSupply.sub(_value);
		emit TokenBurn(msg.sender, _value);
		return true;
	}
	function addAllowedAddress(address _address) public isOwner
	{
		allowedAddress[_address] = true;
	}
	function deleteAllowedAddress(address _address) public isOwner
	{
		require(_address != owner,"only allow user address");
		allowedAddress[_address] = false;
	}
	function addBlockedAddress(address _address) public isOwner
	{
		require(_address != owner,"only allow user address");
		blockedAddress[_address] = true;
	}
	function deleteBlockedAddress(address _address) public isOwner
	{
		blockedAddress[_address] = false;
	}
	function setTransferLock(bool _transferLock) public isOwner returns(bool success)
	{
		transferLock = _transferLock;
		return true;
	}
}

contract SMB is Variable, Event, Admin 
{
    
    using SafeMath for uint256;

	//function() external payable //이건 0.8 에선 에러
    fallback() external payable 
	{
		//컨트렉트에 포함되지 않은 기능을 호출시
		revert("Error due to function call not included in contact");
	}
	
	receive() external payable 
	{
		//컨트렉트 내부에 어떤 기능과 일치하지 않는 경우 호출시
		revert("Error in case of mismatched internal functionality");
	}

	function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) 
	{
		return allowed[tokenOwner][spender];
	}
	
	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
	{
		//allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        allowed[msg.sender][_spender] = _addedValue;
		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
		return true;
	}
	
	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool)
	{
		uint256 oldValue = allowed[msg.sender][_spender];
		if (_subtractedValue > oldValue) 
		{
			allowed[msg.sender][_spender] = 0;
		} 
		else
		{
			//allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
            allowed[msg.sender][_spender] = _subtractedValue;
		}
		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
		return true;
	}
	
	function approve(address _spender, uint256 _value) public returns (bool)
	{
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}
	
    
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
	{
		require(allowedAddress[_from] || transferLock == false, "Transfer lock : true");
		require(!blockedAddress[_from] && !blockedAddress[_to] && !blockedAddress[msg.sender], "Blocked address");
		require(balanceOf[_from] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");
		require(_value <= allowed[_from][msg.sender], "Invalid balance : allowed");

		balanceOf[_from] = balanceOf[_from].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		emit Transfer(_from, _to, _value);

		return true;
	}
	
	function transfer(address _to, uint256 _value) public returns (bool)	
	{
		require(allowedAddress[msg.sender] || transferLock == false, "Transfer lock : true");
		require(!blockedAddress[msg.sender] && !blockedAddress[_to], "Blocked address");
		require(balanceOf[msg.sender] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");

		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
				
		return true;
	}
}  
