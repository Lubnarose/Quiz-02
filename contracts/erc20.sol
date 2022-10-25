// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//base contract 1 (functions virtual)
abstract contract ERC20_STD {
function name() public view virtual returns (string memory);
function symbol() public view virtual returns (string memory);
function decimals() public view virtual returns (uint256);
function totalSupply() public view virtual returns (uint256);
function balanceOf(address _owner) public view virtual returns (uint256 balance);
function transfer(address _to, uint256 _value) public virtual returns (bool success);
function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
function approve(address _spender, uint256 _value) public virtual returns (bool success);
function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);


event Transfer(address indexed _from, address indexed _to, uint256 _value);
event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

//base contract 2
contract Ownership{
    address public contractOwner;
    address public newOwner;

    event TransferOwnership(address indexed _from, address indexed _to);


//constructer initialize state variables in a contract
    constructor (){
        contractOwner = msg.sender;

    }
    function changeOwner( address _to) public {
        require (msg.sender == contractOwner, "only_contratctOwner_can execute");
        newOwner = _to;
    }
    function acceptOwner() public{
    require (msg.sender == newOwner, 'newOwner_can_call_it');
    emit TransferOwnership (contractOwner, newOwner);
    contractOwner = newOwner;
    newOwner = address(0);

    }
}

contract myERC20 is ERC20_STD, Ownership{

//declaring state variables
string public _name;
string public _symbol;
uint256 public _decimals = 1 *10 **decimals(); // decimal of 08
uint256 public _totalSupply;

address public minter;

//The first mapping object, tokenBalances, will hold the token balance of each owner account.
//The second mapping object, allowed, will include all of the accounts approved to withdraw 
//from a given account together with the withdrawal sum allowed for each.
mapping (address => uint256) tokenBalances;
mapping (address => mapping(address => uint256)) allowed;

constructor(address minter_){
_name = 'LubnaToken';
_symbol = 'LBT';
_totalSupply = 1000000;  // fixed supply
minter = minter_;
tokenBalances[minter] = _totalSupply;

}

//(functions override to base contract 1)
function name() public view override returns (string memory){
    return _name;
}
function symbol() public view override returns (string memory){
    return _symbol;
}
function decimals() public view override returns (uint256){
    return _decimals;
}

//totalSupply function will return the number of all tokens allocated by 
//this contract regardless of owner.
function totalSupply() public view override returns (uint256){
    return _totalSupply;
}

//balaceOf function will return the current token balance of an account, identified by 
//its owner’s address.
function balanceOf(address _owner) public view override returns (uint256 balance){
    return tokenBalances[_owner];
}

//transfer function used to move numTokens amount of tokens 
//from the owner’s balance to that of another user, or receiver
function transfer(address _to, uint256 _value) public override returns (bool success){
    require(tokenBalances[msg.sender] >= _value, 'INSUFFICIENT TOKEN');
    tokenBalances[msg.sender] -= _value;
    tokenBalances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}

//transferFrom allows a approved for withdrawal to transfer owner funds to a third-party account.
function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
    uint256 allowedBalance = allowed[_from][msg.sender];
    require(allowedBalance >= _value, 'INSUFFICIENT BALANCE');
    tokenBalances[_from] -= _value;
    tokenBalances[_to] += _value;
    emit Transfer(_from, _to, _value);
    return true;

}

//approve function is used for scenarios where owners are offering tokens on a marketplace
function approve(address _spender, uint256 _value) public override returns (bool success){
    require(tokenBalances[msg.sender] >= _value, 'INSUFFICIENT TOKENS');
    allowed[msg.sender][_spender] -= _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
}

//allowance function returns the current approved number of tokens by an owner
function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
    return allowed [_owner][_spender];
}

}
