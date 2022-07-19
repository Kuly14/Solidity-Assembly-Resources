// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/// @author Kuly14
/// Optimized Ownable contract with a two step ownership transfer process written in assembly.

contract Ownable {
    event TransferOwnershipProposed(address _newOwner);
    event OwnershipTransfered(address _newOwner);

    address public owner;
    address public pendingOwner;

    constructor() {
        // Start Assembly Block
        assembly {
            // Store msg.sender at the 0th slot where the address owner is stored.
            sstore(0, caller())
        }
    }

    modifier onlyOwner() {
        // Start Assembly Block
        assembly {
            // Load owner address from storage slot 0
            let ownr := sload(0)

            // If owner != msg.sender revert
            if iszero(eq(ownr, caller())) {
                revert(0, 0)
            }
        }
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        // Get the event hash to emit it later
        bytes32 eventHash = bytes32(
            keccak256("TransferOwnershipProposed(address)")
        );

        // Start Assembly block
        assembly {
            // Store the newOwner at slot 1 where pendingOwner is stored
            sstore(1, newOwner)

            // Store newOwner to memory so we can emit the data
            mstore(0x80, newOwner)

            // Emit the data stored at memory address 0x80, with length of 32 bytes
            log1(0x80, 32, eventHash)
        }
    }

    function claimOwnership() public {
        // Get the event hash
        bytes32 eventHash = bytes32(keccak256("OwnershipTransfered(address)"));

        // Start Assembly block
        assembly {
            // Get load pendingOwner from storage to the stack
            let pending := sload(1)

            // Check if the caller is the pending owner
            if iszero(eq(caller(), pending)) {
                // Revert if not
                revert(0, 0)
            }

            // Store pendingOwner to memory from stack
            mstore(0x80, pending)

            // Store pending owner at the 0th slot. So owner = pendingOwner
            sstore(0, pending)

            // Change the pending owner address to address(0) and get a gas refund
            sstore(1, 0x00)

            // Emit the event
            log1(0x80, 32, eventHash)
        }
    }
}
