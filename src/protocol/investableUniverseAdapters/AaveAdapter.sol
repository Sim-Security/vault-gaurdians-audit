// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IPool} from "../../vendor/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AaveAdapter {
    using SafeERC20 for IERC20;

    IPool public immutable i_aavePool;

    constructor(address aavePool) {
        i_aavePool = IPool(aavePool);
    }

    function aaveInvest(IERC20 asset, uint256 amount) internal {
        asset.approve(address(i_aavePool), amount);
        i_aavePool.supply(address(asset), amount, address(this), 0);
    }

    function aaveDivest(IERC20 token, uint256 amount) internal returns (uint256 amountOfAssetReturned) {
        amountOfAssetReturned = i_aavePool.withdraw(address(token), amount, address(this));
    }
}