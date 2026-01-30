// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SATH_TOKEN{

    address public owner;
    mapping(address=>uint) public balances;
    uint public Total_Supply;
    string public Token_Name="SATHWIKCOIN";
    string public Token_Symbol="SAT";

    //Allownaces/Delegations
    mapping(address=>mapping(address=>uint)) public allowances;

    //Used for tracking  
    event Approval(address indexed owner,address indexed spender,uint value);
    event Transfer(address indexed from,address indexed to,uint value);

    constructor(){
        owner=msg.sender;
    }

    //Allowances/Delegations approach
    //1.First- Create an Allownance//Approve an Allowance, _delegator=person spending 
    function approve(address _spender,uint amount) public returns(bool success){
        allowances[msg.sender][_spender]=amount;
        emit Approval(msg.sender,_spender,amount);
        return true;
    }

    //2.Second-Create Transfer function for the Allownaces 
    function transferFrom(address _from,address _to,uint amount) public returns (bool success){
        //check allownace is greater than the amount you are sending...delegatee
        uint allownace=allowances[_from][msg.sender];
        require(allownace>=amount,"Not Enough");
        //check the delegator balance,as the amount will be deducted from his account
        uint balance=balances[_from];
        require(balance>=amount,"Balance not Sufficient");

        //state change
        balances[_from]-=amount;
        balances[_to]+=amount;
        allowances[_from][msg.sender]-=amount;

        emit Transfer(_from, _to, amount);

        return true;
    }

    //create a own mint
    //create mint for others
    //transfer Amount

    function Token_Mint(uint amount) public{
        require(owner==msg.sender,"Not the Owner!");
        balances[owner]+=amount;
        Total_Supply+=amount;

        emit Transfer(address(0), owner, amount);
    }

    //Mint to
    function MintTo(address To,uint amount) public{
        require(owner==msg.sender,"Only Owner can Mint to Others");
        balances[To]+=amount;
        Total_Supply+=amount;

        emit Transfer(address(0), To, amount);
    }

    //Trnasfer
    function transfer(address To,uint amount) public{
        uint OwnerBalances=balances[msg.sender];
        require(amount<=OwnerBalances,"Balance not Sufficient");
        balances[msg.sender]-=amount;
        balances[To]+=amount;

        emit Transfer(msg.sender, To, amount);
    }
}
