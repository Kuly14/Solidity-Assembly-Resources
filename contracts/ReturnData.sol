pragma solidity 0.8.7;

contract ReturnData {
    function getReturnData(address _contractAddress)
        public
        returns (bytes32, bytes32)
    {
        // Selector is pushed to the stack
        bytes4 selector = bytes4(keccak256("show()"));

        // Start the assembly block
        assembly {
            // Get free memory pointer
            let pointer := mload(0x40)

            // Store the selector into memory
            mstore(pointer, selector)

            // Call the TestContract with
            // 1. Reaming gas
            // 2. The address you want to call
            // 3. How much WEI you want to send
            // 4. Pointer to memory where the calldata is stored in this case just the selector
            // 5. Length of the call data
            // 6. Where to store the return data, in this case 0 because we will get it other way
            // 7. Length of the return data
            let success := call(gas(), _contractAddress, 0, pointer, 4, 0, 32)

            // Check if the call was successful. If it was it will return 1 so iszero will return false
            if iszero(success) {
                revert(0, 0)
            }

            // Get the size of the return data
            let size := returndatasize()

            // We copy the return data to memory
            returndatacopy(add(pointer, 32), 0, size)

            // Return the data from address where we stored the data
            return(add(pointer, 32), size)
        }
    }
}

contract TestContract {
    function show() public view returns (bytes32, bytes32) {
        return (
            bytes32(keccak256(abi.encode(msg.sender))),
            bytes32(keccak256(abi.encode(tx.origin)))
        );
    }
}
