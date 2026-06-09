# Round178 Gentle Quest Markers

Proof-only cozy interaction / gentle task marker candidates for StudyGame V02 visual rebuild.

## Boundary

- Runtime status: proof only.
- No runtime wiring.
- No `ThemeProfile`, `AssetResolver`, shared test, or data changes.
- Runtime boundary string in `manifest.json`: `proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes`.
- No `art_target_locked`, `runtime_visual_match`, or approval claim.

## Contents

- `raw/`: pure `#00ff00` chroma source/provenance PNGs.
- `normalized_192x192/`: transparent RGBA marker candidates.
- `proof/round178_gentle_quest_markers_contact_sheet.png`: checker-backed proof contact sheet.
- `manifest.json`: item list, stable logical IDs, validation data, paths, gate result, and risks.
- `generate_validate_manifest.py`: local synthesis, normalization, contact sheet, and manifest validator.

## Candidate Set

- `interaction_marker.look_sparkle_ring`
- `interaction_marker.small_talk_bubble_blank`
- `interaction_marker.lost_item_glow_leaf`
- `interaction_marker.gift_ready_soft_wrap`
- `interaction_marker.helper_hand_soft_icon`
- `interaction_marker.revisit_memory_twinkle`
- `interaction_marker.shop_available_coin_leaf`
- `interaction_marker.album_new_card_glow`
- `interaction_marker.home_ready_lantern`
- `interaction_marker.calm_question_leaf`

## Alpha Provenance

Per `LESSON-022`, transparency is verified from the final PNG pixels. The pack uses local PIL synthesis with raw `#00ff00` chroma evidence and final RGBA output; white-background glass cleanup was not used. The manifest records transparent-corner checks, edge alpha ratios, residue scans, and background-block risk for every candidate.

## Visual Notes

The pack avoids visible text labels, exclamation-heavy urgency, school/test motifs, scores, badges, and worksheet-like cues. These are small, soft, Animal Crossing-like world interaction overlays and need later in-scene 1280 review before any runtime consideration.
