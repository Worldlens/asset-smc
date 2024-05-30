module nft::nft {
    use std::string::String;
    use sui::event;

    use sui::tx_context::{sender};
    use nft::genesis::{AdminCap};

    public struct WorldlensNFT has key, store {
        id: UID,
        name: String,
        barcode: u64,
        description: String,
        image: String,
    }

    public struct NFTMinted has copy, drop {
        /// ID of the nft
        nft_id: ID,
        /// The address of the NFT minter
        minted_by: address,
    }

    /// Mint a new nft with the given `name`, `traits` and `url`.
    /// The object is returned to sender and they're free to transfer
    /// it to themselves or anyone else.
    public fun mint(
        _: &mut AdminCap,
        name: String,
        barcode: u64,
        description: String,
        image: String,
        ctx: &mut TxContext
    ): WorldlensNFT {
        let id = object::new(ctx);

        event::emit(NFTMinted {
            nft_id: id.to_inner(),
            minted_by: ctx.sender(),
        });

        // transfer::public_transfer(WorldlensNFT { id, name, barcode, description, image }, sender(ctx));
        WorldlensNFT { id, name, barcode, description, image }
    }

    /// As the nft grows, owners can change the image to reflect
    /// the nft's current state and look.
    public fun set_image(nft: &mut WorldlensNFT, image: String) {
        nft.image = image;
    }

    /// It's a good practice to allow the owner to destroy the NFT
    /// and get a storage rebate. Not a requirement and depends on
    /// your use case. At last, who doesn't love puppies?
    public fun destroy(_: &mut AdminCap, nft: WorldlensNFT) {
        let WorldlensNFT { id, name: _, image: _, description: _, barcode: _ } = nft;
        id.delete()
    }

    // Getters for properties.
    // Struct fields are always private and unless there's a getter,
    // other modules can't access them. It's up to the module author
    // to decide which fields to expose and which to keep private.

    /// Get the nft's `name`
    public fun name(nft: &WorldlensNFT): String { nft.name }

    /// Get the nft's `url`
    public fun image(nft: &WorldlensNFT): String { nft.image }
}
