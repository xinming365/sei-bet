/**
 *Submitted for verification at Arbiscan on 2023-02-21
*/

pragma solidity ^0.8.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }


    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


abstract contract Pausable is Context {

    event Paused(address account);


    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }


    function paused() public view returns (bool) {
        return _paused;
    }


    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }


    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }


    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }


    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


// File: @openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
abstract contract ERC20Pausable is ERC20, Pausable {
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}


pragma solidity >=0.5.0;

interface ICamelotFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function owner() external view returns (address);

    function feePercentOwner() external view returns (address);

    function setStableOwner() external view returns (address);

    function feeTo() external view returns (address);

    function ownerFeeShare() external view returns (uint256);

    function referrersFeeShare(address) external view returns (uint256);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function feeInfo()
        external
        view
        returns (uint _ownerFeeShare, address _feeTo);
}


pragma solidity >=0.6.2;


interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface ICamelotRouter is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        address referrer,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        address referrer,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        address referrer,
        uint deadline
    ) external;

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}


contract emo is ERC20Pausable, Ownable {
    using SafeMath for uint256;

    event AddLiquidity(uint256 tokenAmount, uint256 ethAmount, uint256 timestamp);

    ICamelotFactory private immutable factory;
    ICamelotRouter private immutable swapRouter;
    AggregatorV3Interface private priceFeed;
    
    
    uint256 private constant DECIMAL_FACTOR = 10**18;
    uint256 private constant INITIAL_SUPPLY = 100_000_000 * DECIMAL_FACTOR;
    uint256 private constant MAX_SUPPLY = 1_000_000_000 * DECIMAL_FACTOR;

    uint256 private constant DAILY_RATE = 100; // 每日收益率，可以根据实际情况进行调整
    uint256 private constant INVESTMENT_DURATION = 365; // 投资期限（天数）
    uint256 private constant MINIMUM_HOLDING_PERIOD = 1; // 最短持有期限（天数）
    uint256 private constant PENALTY_RATE = 20; // 持有时间不足最短持有期限时的罚金率（百分比）

    uint256 private currentPrice; // 当前代币价格
    uint256 private previousPrice; // 上一个价格
    uint256 private lastPriceUpdateTimestamp; // 最后更新价格的时间戳

    uint256 private upEmotionRewardRate = 1;
    uint256 private downEmotionReardRate = 1;

    uint256 public settlementInterval = 30 minutes;
    uint256 public lastSettlementTime;
   
    mapping(address => uint256) private baseFunds;
    mapping(address => uint256) private depositTimestamps;

    enum BetOption {PriceUp, PriceDown}
    enum BetStatus {Open, Closed, Settled}

    struct Bet {
        BetOption betOption;
        address betAddr;
        uint256 betAmount;
        uint256 betTimestamp;
        BetStatus betStatus;
        uint256 betPrice;
    }

    // mapping(BetOption=>address) betPool;
    mapping(address=>Bet) public bets;
    

    constructor(address _factory, address _swapRouter, address _dataFeed, uint8 decimal) public ERC20("emo","EMO") {        
        factory = ICamelotFactory(_factory);
        swapRouter = ICamelotRouter(_swapRouter);
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        _setupDecimals(decimal);
        _mint(msg.sender, INITIAL_SUPPLY); // initial supply
    }

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal{
        _approve(address(this), address(swapRouter), tokenAmount);
        try swapRouter.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, address(0), block.timestamp) {
            emit AddLiquidity(tokenAmount, ethAmount, block.timestamp);
        } catch {}
    }       

    function rescueToken(address tokenAddress) external onlyOwner {
        IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
    }

    function updatePrice(uint256 price) external onlyOwner {
        previousPrice = currentPrice;
        currentPrice = price;
        lastPriceUpdateTimestamp = block.timestamp;
    }

    function getLatestPrice() public view returns(uint256){
        ( , int256 answer,  ,  , ) = priceFeed.latestRoundData();
        return uint256(answer);
    }

    function startBet(BetOption _betOption) external payable{ 
        Bet storage newBet = bets[msg.sender];
        newBet.betAddr = msg.sender;
        newBet.betAmount = msg.value;
        newBet.betOption = _betOption;
        newBet.betTimestamp = block.timestamp;
        newBet.betStatus = BetStatus.Open;
        newBet.betPrice = getLatestPrice();

        transfer(address(this), msg.value);
    }

    function settleBet(Bet[] calldata bets_arr) private onlyOwner{
        uint256 payAmount = 0  ; 
        address [] memory winnerAddress = new address [](bets_arr.length);
        uint256[] memory  winnerWeights = new uint256[](bets_arr.length);
        uint256 winnerTotalWeight = 0;

        currentPrice = getLatestPrice();
        for (uint256 i=0; i< bets_arr.length; i++){
            Bet memory bet = bets_arr[i];
            // require(block.timestamp >= lastSettlementTime + settlementInterval, "settlement can noly occur every 30 minutes" );
            if ((currentPrice > bet.betPrice && bet.betOption==BetOption.PriceUp) || (currentPrice < bet.betPrice && bet.betOption==BetOption.PriceDown)){
                winnerWeights[i] = bet.betAmount;
                winnerAddress[i] = bet.betAddr;
                winnerTotalWeight += bet.betAmount;
            }
            else{
                payAmount += bet.betAmount;
            }
        }

        for (uint256 i=0; i<winnerAddress.length; i++){
            
            _transfer(address(this), winnerAddress[i], winnerWeights[i].div(winnerTotalWeight).mul(payAmount));
        }

    }

    function updateBaseFunds() external {
        require(balanceOf(msg.sender) > 0, "No balance to update");
        baseFunds[msg.sender] = balanceOf(msg.sender);
        depositTimestamps[msg.sender] = block.timestamp;
    }

    function getBaseFunds(address account) external view returns (uint256) {
        return baseFunds[account];
    }

    function getProfit(address account) external view returns (int256) {
        require(balanceOf(account) > 0, "No balance to calculate profit");
        int256 currentBalance = int256(balanceOf(account));
        int256 baseBalance = int256(baseFunds[account]);
        return currentBalance - baseBalance;
    }

    function deposit(uint256 amount) external {
        require(totalSupply().add(amount) <= MAX_SUPPLY, "Maximum supply exceeded");
        _transfer(msg.sender, address(this), amount);
        _stakeTokens(amount);
    }

    function withdraw(uint256 amount) external {
        uint256 penalty = _calculatePenalty(amount);
        uint256 finalAmount = amount.sub(penalty);
        _unstakeTokens(finalAmount);
        _transfer(address(this), msg.sender, finalAmount);
    }

    function _stakeTokens(uint256 amount) private {
        require(amount > 0, "Invalid amount");
        require(baseFunds[msg.sender] == 0, "Cannot stake while having existing stake");
        require(depositTimestamps[msg.sender] == 0, "Cannot stake while having existing stake");

        baseFunds[msg.sender] = amount;
        depositTimestamps[msg.sender] = block.timestamp;

    }

    function _unstakeTokens(uint256 amount) private {
        require(amount > 0, "Invalid amount");
        require(amount <= baseFunds[msg.sender], "Insufficient staked balance");
        require(_isHoldingPeriodFulfilled(), "Minimum holding period not fulfilled");

        baseFunds[msg.sender] = 0;
        depositTimestamps[msg.sender] = 0;
    }

    function _isHoldingPeriodFulfilled() private view returns (bool) {
        uint256 holdingPeriod = block.timestamp.sub(depositTimestamps[msg.sender]);
        return holdingPeriod >= MINIMUM_HOLDING_PERIOD.mul(1 days);
    }

    function _calculatePenalty(uint256 amount) private view returns (uint256) {
        if (!_isHoldingPeriodFulfilled()) {
            uint256 penaltyPercentage = PENALTY_RATE;
            return amount.mul(penaltyPercentage).div(100);
        } else {
            return 0;
        }
    }

    function _calculateDailyProfit() private  returns (uint256) {
        uint256 timeElapsed = block.timestamp.sub(depositTimestamps[msg.sender]);
        uint256 profitPercentage = DAILY_RATE.mul(timeElapsed).div(1 days);
        currentPrice = getLatestPrice();
        uint256 up_down_percentage=0;
        if (currentPrice>previousPrice){
            up_down_percentage = upEmotionRewardRate.add((currentPrice.sub(previousPrice)).div(previousPrice));
        }else if (currentPrice<previousPrice){
            up_down_percentage = downEmotionReardRate.add((previousPrice.sub(currentPrice)).div(previousPrice));
        }

        return baseFunds[msg.sender].mul(profitPercentage.add(up_down_percentage)).div(100);
    }

    function claimProfit() external {
        require(_isHoldingPeriodFulfilled(), "Minimum holding period not fulfilled");

        uint256 profit = _calculateDailyProfit();
        require(profit > 0, "No profit to claim");

        _mint(msg.sender, profit);
        depositTimestamps[msg.sender] = block.timestamp;
    }
}      