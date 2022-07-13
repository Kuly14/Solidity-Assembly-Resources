pragma solidity 0.8.7;

contract SendEther {
    receive() external payable {}

    function sendEth(address _to, uint _amount) external payable {
        // We first declare bool variable to see if the transfer was succssful.
        bool success;
        assembly {
            // We use the call opcode to call the _to address with the specified amount.abi
            // The gas() function just shows how much gas is left.

            // To see what are the other inputs go to evm.codes and search the call opcode.
            success := call(gas(), _to, _amount, 0, 0, 0, 0)
        }
        require(success, "Transfer Failed");
    }
}
