pragma solidity >=0.4.21 <0.7.0;

//@title LOP pool interface
interface ILOPPool {
//---------------------------------------------------------
//@dev Mint and burn interface through deposit() and withdraw() to the pool
    event DepositReceived(address _from, uint256 amount);
    event WithdrawalCompleted(address _to, uint256 amount);

    //@notice deposit underlying in the pool
    function deposit(uint256 amount) external payable;

    //@notice redeem pool token for underlying
    function redeem(uint256 _amount) external;
}