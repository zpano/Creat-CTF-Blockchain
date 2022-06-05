
a CERTIFICATE----- solidity ^0.7.0;

contract Vuln {
    address public owner;
    string public name     = "Chain";
    string public symbol   = "CHA";
    uint8  public decimals = 18;
    uint public totalSupply=10000000000;
    bool  public isLoan=false;
    bool public solved;
    event  Approval(address indexed from, address indexed to, uint number);
    event  Transfer(address indexed from, address indexed to, uint number);
    event  Deposit(address indexed to, uint number);
    event  Withdrawal(address indexed from, uint number);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;
    constructor()public{
        owner=msg.sender;
        balanceOf[owner]=totalSupply/2;
        balanceOf[address(this)]=totalSupply/2;
    }


    function withdraw(uint number) public {
        require(balanceOf[msg.sender] >= number);
        balanceOf[msg.sender] -= number;
        (msg.sender).transfer(number);
        emit Withdrawal(msg.sender, number);
    }


    function approve(address to, uint number) public returns (bool) {
        allowance[msg.sender][to] = number;
        emit Approval(msg.sender, to, number);
        return true;
    }
    function transfer(address _to, uint _value) public returns (bool) {
        require(balanceOf[msg.sender] - _value >= 0);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    return true;
    }

    function fakeflashloan(uint256 value,address target,bytes memory data) public{
        require(isLoan==false&&value>=0&&value<=1000);
        balanceOf[address(this)]-=value;
        balanceOf[target]+=value;

        address(target).call(data);

        isLoan=true;
        require(balanceOf[target]>=value);
        balanceOf[address(this)]+=value;
        balanceOf[target]-=value;
        isLoan=false;
    }

    function transferFrom(address from, address to, uint number)
        public
        returns (bool)
    {
        require(balanceOf[from] >= number);

        if (from != msg.sender && allowance[from][msg.sender] != 2**256-1) {
            require(allowance[from][msg.sender] >= number);
            allowance[from][msg.sender] -= number;
        }

        balanceOf[from] -= number;
        balanceOf[to] += number;

        emit Transfer(from, to, number);

        return true;
    }
    
    function issolved() public {

        require(balanceOf[msg.sender]>10000);
        require(allowance[address(this)][msg.sender]>10000);
        
        
    }
}
