pragma solidity 0.8.7;

/// Simple contract that shows how memory works in assembly
/// @author Kulk0

contract Memory {
    receive() external payable {}

    function show(
        address to,
        address from,
        uint x
    ) public returns (bytes32) {
        assembly {
            // Get a free memory pointer
            let ptr := mload(0x40)

            // Store to address to memory
            mstore(ptr, to)

            // Store from address to memory ptr + 32 bytes
            mstore(add(ptr, 32), from)

            // Store x uint to memory + 64 bytes
            mstore(add(ptr, 64), x)

            // Call to address and send x amount of wei
            let success := call(gas(), to, x, 0, 0, 0, 0)

            // Store the return value in memory ptr + 96
            mstore(add(ptr, 96), success)

            // Check if the call was successful
            if eq(success, 0x00) {
                revert(0, 0) // Revert if not
            }

            // Return the success variable at memory address ptr + 96
            return(add(ptr, 96), 32)
        }
    }
}
