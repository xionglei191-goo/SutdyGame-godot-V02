# Round173 Resources / Shop Items Proof Pack

Proof-only candidate item icons for V02.39 visual rebuild.

- Category: `resource_shop_item`
- Runtime boundary: `candidate_only_no_asset_resolver_or_themeprofile_mapping`
- Overall gate: `pass`
- Atlas: `assets/art/visual_rebuild/round173/resources_shop_items/resources_shop_items_atlas_128.png`
- Proof image: `assets/art/visual_rebuild/round173/resources_shop_items/resources_shop_items_proof_128.png`
- Normalized cell: `128x128`, transparent PNG, fixed-cell atlas.
- Source/raw evidence remains in this collaboration folder.

No ThemeProfile, AssetResolver, runtime, data, or test mapping is included.

## Items

- `branch_bundle` -> `assets/art/visual_rebuild/round173/resources_shop_items/branch_bundle.png`; bbox=[11, 14, 117, 113]; visible_key_pixels=0
- `pebble_pair` -> `assets/art/visual_rebuild/round173/resources_shop_items/pebble_pair.png`; bbox=[11, 25, 117, 103]; visible_key_pixels=0
- `wildflower_small` -> `assets/art/visual_rebuild/round173/resources_shop_items/wildflower_small.png`; bbox=[22, 11, 106, 117]; visible_key_pixels=0
- `orange_bowl_or_orange_tag` -> `assets/art/visual_rebuild/round173/resources_shop_items/orange_bowl_or_orange_tag.png`; bbox=[11, 14, 117, 114]; visible_key_pixels=0
- `pet_food` -> `assets/art/visual_rebuild/round173/resources_shop_items/pet_food.png`; bbox=[11, 15, 117, 112]; visible_key_pixels=0
- `sunny_snack_basket` -> `assets/art/visual_rebuild/round173/resources_shop_items/sunny_snack_basket.png`; bbox=[11, 18, 117, 110]; visible_key_pixels=0
- `fabric_scrap` -> `assets/art/visual_rebuild/round173/resources_shop_items/fabric_scrap.png`; bbox=[11, 24, 117, 104]; visible_key_pixels=0
- `book_stack_or_story_book` -> `assets/art/visual_rebuild/round173/resources_shop_items/book_stack_or_story_book.png`; bbox=[12, 11, 116, 117]; visible_key_pixels=0
- `coin_stack` -> `assets/art/visual_rebuild/round173/resources_shop_items/coin_stack.png`; bbox=[11, 17, 117, 110]; visible_key_pixels=0
- `tiny_seed_packet` -> `assets/art/visual_rebuild/round173/resources_shop_items/tiny_seed_packet.png`; bbox=[11, 11, 116, 117]; visible_key_pixels=0

## Validation

Run from repo root:

```bash
python3 docs/collaboration/round173_visual_rebuild_asset_generation/resources_shop_items/process_round173_resources_shop_items.py
```

Gate requires fixed 128x128 cells, alpha, non-empty bbox, and zero visible #ff00ff key pixels.
