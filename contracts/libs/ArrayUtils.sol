// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ArrayUtils {
    function includes(uint256[] storage _array, uint256 _value)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _array.length; i++) {
            if (_array[i] == _value) return true;
        }
        return false;
    }

    function map(
        uint256[] memory _array,
        function(uint256) pure returns (uint256) _f
    ) internal pure returns (uint256[] memory r) {
        r = new uint256[](_array.length);
        for (uint256 i = 0; i < _array.length; i++) {
            r[i] = _f(_array[i]);
        }
    }

    function reduce(
        uint256[] memory _array,
        function(uint256, uint256) pure returns (uint256) _f
    ) internal pure returns (uint256 r) {
        r = _array[0];
        for (uint256 i = 1; i < _array.length; i++) {
            r = _f(r, _array[i]);
        }
    }

    function includes(address[] storage _array, address _value)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _array.length; i++) {
            if (_array[i] == _value) return true;
        }
        return false;
    }

    function map(
        address[] memory _array,
        function(address) pure returns (address) _f
    ) internal pure returns (address[] memory r) {
        r = new address[](_array.length);
        for (uint256 i = 0; i < _array.length; i++) {
            r[i] = _f(_array[i]);
        }
    }
}
