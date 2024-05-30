// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module nft::genesis {

  // Sui imports.
  use sui::package::{Self};
  use sui::tx_context::{sender};

  // Manager capability assigned to whoever deploys the contract
  // AdminCap is transferrable in case the owner needs to change addresses.
  public struct AdminCap has key, store { 
    id: UID 
  }

  // OTW to create the publisher
  public struct GENESIS has drop {}

  public struct SharedItem has key { id: UID }

  fun init(otw: GENESIS, ctx: &mut TxContext) { 

    // Claim the Publisher for the Package
    let publisher = package::claim(otw, ctx);

    // Transfer the Publisher to the sender
    transfer::public_transfer(publisher, sender(ctx));

    // Create a shared object
    transfer::share_object(SharedItem {
      id: object::new(ctx)
    });

    transfer::public_transfer(AdminCap {
        id: object::new(ctx)
      }, sender(ctx));
  }
}