// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

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
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
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

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract paymentProcessor is Pausable,Ownable{

     struct TransferInformation {
        uint amount;
        uint time;
    }

    mapping(address=>TransferInformation[]) private data;
    mapping(address=>uint) private registrationQuantity;

    address authorizedWallet;
    IERC20 usdtToken;

    event deposit(address indexed sender, uint amount, uint time);

    constructor(){

        //cambiar por el contrato erc20 a utilizar
        usdtToken = IERC20(0x838F9b8228a5C95a7c431bcDAb58E289f5D2A4DC);

        //cambiar por la wallet que realizara el retiro
        authorizedWallet=0x838F9b8228a5C95a7c431bcDAb58E289f5D2A4DC;
    }

    receive() external payable {}

    fallback() external payable {}

    //funcion para retirar los bnb almacenado en el contrato
    function withdrawBnB() external onlyOwner {
        _withdrawBnB();
    }

    //funcion para retirar la liquidez en token almacenado en el contrato
    function withdrawTokenLiquidity(uint _amount) external onlyOwner{
        _withdrawInvestment(_msgSender(),_amount);
    }

    //funcion para retirar fondos para el usuario
    function  withdrawals(uint _amount) external{
        _withdrawInvestment(_msgSender(),_amount);
    }

    //funcion para depositar token erc20 en el contrato
    //retorna una array con el monto depositado y la fecha en milisegundos
    function deposits(uint amount)external {
        _deposits(_msgSender(),amount);
    }
   
    //funcion para consutal el balance de tokens erc20 en el contrato
    function getBalanceToken() external view returns(uint){
        return usdtToken.balanceOf(address(this));
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    //funcion para consultar la cantidad de deposito que a realizado el usuario
    //retorna un entero con la cantidad de depositos realizado
    function getRegistrationQuantity(address _user)external view returns(uint){  
        return data[_user].length;
    }

    //funcion para consultar un registo especifico de depostio del usuario
      //retorna una array con el monto depositado y la fecha en milisegundos
    function getData(address _user,uint _unit)external view returns(uint[] memory){
        uint[] memory info = new uint[](2);
        info[0]=data[_user][_unit].amount;
        info[1]=data[_user][_unit].time;
        return info;
    }

    function _deposits(address _from,uint _amount) private {
        require(_from != address(0),"the from has to be different from 0");
        require(usdtToken.balanceOf(_from)>=1 ether,"insufficient balance");
        require(usdtToken.allowance(_from, address(this))>=1 ether,"insufficient allowance");
        usdtToken.transferFrom(_from, address(this), _amount);
        setData(_amount);
    }

    //funcion para registrar el deposito del usuario
    function setData(uint _amount)private returns(uint[] memory){
        uint[] memory info = new uint[](2);
        data[_msgSender()].push(TransferInformation(_amount,block.timestamp));
        registrationQuantity[_msgSender()]=data[_msgSender()].length;
        info[0]=_amount;
        info[1]=block.timestamp;
        emit deposit(_msgSender(), _amount, block.timestamp);
        return info;
    }

    function _withdrawInvestment(address _sender,uint _amount) internal {
        require(_sender != address(0),"the from has to be different sender 0");
        require(_amount >0);
        require(_sender==owner() || _sender==authorizedWallet,"unauthorized wallet");
        require(usdtToken.balanceOf(address(this)) > 0,"wrong amount");
        require(_amount >0);
        usdtToken.transfer(owner(),_amount);
    }

    function _withdrawBnB() internal  { 
        require(address(this).balance > 0, "Address: insufficient balance");
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

}
