pragma solidity ^0.5.16;

contract BasicToken {
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 public totalSupply_;

    using SafeMath for uint256;


    function totalSupply() public view returns (uint256) {
	    return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens>0);
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
    function  mul( uint256 _a ,  uint256 _b ) internal  pure returns ( uint256 )   {

     if   ( _a ==   0 )   {
       return   0 ;
     } uint256 c =  _a *  _b ;
     require ( c /  _a ==  _b );

     return  c ;
   }
}


contract tokenForIco is BasicToken{
    string public name = 'ICOToken';
    string public symbol = 'ITK';
    uint256 public decimals = 18;
    address public icoAddress;
    address private owner;

   constructor() public BasicToken(){
        totalSupply_ = 100000000 * 10e18;
        owner = msg.sender;
       balances[address(this)] = totalSupply_;
    }

    modifier icoOnly {
        require(msg.sender == icoAddress || msg.sender == owner);
        _;
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    function setIcoAddress(address _icoContract) public ownerOnly{
        require(_icoContract != address(0));
        icoAddress = _icoContract;
    }

    function buyTokens(address _receiver, uint256 _amount) public icoOnly{
        require(_receiver != address(0));
        require(_amount > 0);
        if (msg.sender == owner) {
            _amount = _amount.mul(10e17);
        }
        require(_amount <= balances[address(this)]);
        balances[address(this)] = balances[address(this)].sub(_amount);
        balances[_receiver] = balances[_receiver].add(_amount);
        emit Transfer(address(this), _receiver, _amount);

    }

}
