pragma solidity ^0.6.7;

// Import interface for ERC20 standard
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/interfaces/ILOPPool.sol";
import "contracts/LOPPoolTemplates/TemplatesConfig.sol";
import "contracts/LOPPoolTemplates/aave/ILendingPoolAddressesProvider.sol";
import "contracts/LOPPoolTemplates/aave/ILendingPool.sol";
import "contracts/LOPPoolTemplates/aave/IaTokens.sol";

//@title Aave pool template
//@TODO refactor to put as much code as possible in aaveConfig
contract AavePool is ILOPPool, ERC20 {
    using SafeERC20 for ERC20;

    address public underlyingAsset;
    address public underlyingAcceptedCurrency;

    ILendingPoolAddressesProvider public provider;
    ILendingPool public aavePool;
    TemplatesConfig public aaveConfig;

    event DepositCompleted(address _from, uint256 amount);
    event WithdrawalCompleted(address _to, uint256 amount);

    constructor(address configAddress,
        address _underlyingAcceptedCurrency,
        string memory _name,
        string memory _symbol
    ) public ERC20(_name, _symbol) {
        aaveConfig = TemplatesConfig(configAddress);
        provider = ILendingPoolAddressesProvider(
            aaveConfig.aaveAddressProvider()
        );
        aavePool = ILendingPool(provider.getLendingPool());
        underlyingAsset = address(0);
        underlyingAcceptedCurrency = _underlyingAcceptedCurrency;
    }

    //@notice update the aave lending pool
    //@dev called from the front only if addresses don't match
    modifier checkPoolAddress {
        if (aavePool != ILendingPool(provider.getLendingPool())) {
            aavePool = ILendingPool(provider.getLendingPool());
        }
        _;
    }

    //@dev returns the pool balance of aTokens in the reserve
    function totalPoolHoldings() public view returns (uint256 poolBalance) {
        (poolBalance, , , , , , , , , , ) = aavePool.getUserReserveData(
            underlyingAsset,
            address(this)
        );
    }

    //@notice deposit in the IV pool
    //@param _amount is the amount of underlying reserve token to be deposited
    function deposit(uint256 _amount) override external payable checkPoolAddress {
        require(
            _amount >= aaveConfig.MINIMUM_DEPOSIT(),
            "Deposit must be at least one dollar"
        );
        ERC20 reserve = ERC20(underlyingAsset);
        reserve.safeTransferFrom(
            _msgSender(),
            address(this),
            _amount
        ); //transfer user funds to this contract
        //uint256 before = totalPoolHoldings();
        reserve.approve(provider.getLendingPoolCore(), _amount);
        aavePool.deposit(
            underlyingAsset,
            _amount,
            aaveConfig.aaveReferralCode()
        ); //if deposit fails transaction reverts
        // after= totalPoolHoldings(_reserve);
        // require(before+_amount==after);
        uint256 poolHoldings = totalPoolHoldings();
        uint256 minted = poolHoldings == 0
            ? _amount
            : (_amount * totalSupply()) / poolHoldings;
        _mint(_msgSender(), minted); //_amount/totalpoolholdings == minted/totalsupply
        emit DepositCompleted(_msgSender(), _amount);
    }

    //@notice withdraw from the pool
    //@dev after Burning transfer the underlyingAcceptedCurrency amount to _to
    //@param _amount is the amount of LOP tokens to be redeemed
    //@param underlyingAddress of the aToken
    function redeem(uint256 _amount) override external {
        uint256 amount = _amount > balanceOf(_msgSender())
            ? balanceOf(_msgSender())
            : _amount;
        _burn(_msgSender(), _amount);
        //@TODO get the aTokenAddress from somewhere
        uint256 underlyingAmount = amount * totalPoolHoldings() / totalSupply();
        IaToken(underlyingAsset).redeem(underlyingAmount);
        IERC20(underlyingAcceptedCurrency).transfer(_msgSender(), underlyingAmount);
        emit WithdrawalCompleted(_msgSender(), amount);
    }
//--------------------------------------
// TODO special aave pool functionality to redirect interest to the clan's pooltogether-pod
//--------------------------------------
}

