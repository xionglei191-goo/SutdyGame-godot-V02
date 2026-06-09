# Round172 Proof-Only Asset Generation Summary

Date: 2026-06-08

Scope: agent-generated proof-only props for the V02.39 visual rebuild composition kit. This round fills small town/home props and completes A-Z memory-palace prop-first anchor candidates.

## Delegation

| Agent Scope | Asset Category | Result |
|---|---|---|
| Worker H | town life props | PASS |
| Worker I | home yard props | PASS |
| Worker J | A-M memory-palace anchor props | PASS |
| Worker K | N-Z memory-palace anchor props | PASS |

All workers wrote only to their assigned `assets/art/visual_rebuild/round172/` and `docs/collaboration/round172_visual_rebuild_asset_generation/` folders. No runtime, `AssetResolver`, `ThemeProfile`, data JSON, or shared runner mapping was added.

## Candidate Assets

| Category | Asset Path | Count / Cell | Gate |
|---|---|---:|---|
| town props | `assets/art/visual_rebuild/round172/town_props/round172_town_props_raw_chroma_4x2_v002_128x128_atlas.png` | 8, `128x128` | PASS |
| home yard props | `assets/art/visual_rebuild/round172/home_yard_props/home_yard_props_128x128_atlas.png` | 8, `128x128` | PASS |
| A-M anchor props | `assets/art/visual_rebuild/round172/anchor_props_a_m/round172_anchor_props_a_m_128x128_atlas_v001.png` | 13, `128x128` | PASS |
| N-Z anchor props | `assets/art/visual_rebuild/round172/anchor_props_n_z/round172_anchor_props_n_z_128x128_atlas_v001.png` | 13, `128x128` | PASS |

## Godot Proof

Command:

```bash
godot --headless --path . --script tests/capture_round172_props_preview.gd
```

Output:

`docs/collaboration/round172_visual_rebuild_asset_generation/round172_props_godot_preview_1280x720_v001.png`

## Validation

```bash
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round172
```

Result: `4` manifests, `failed_count: 0`.

Anchor identity check:

- Letters covered: `ABCDEFGHIJKLMNOPQRSTUVWXYZ`
- Unique letters: `26`
- Stable `anchor_id` / `core_word` mismatches against `data/maps/world_map.json`: `0`

## Read

Strengths:

- Round172 fills composition-friendly prop categories that were still missing after terrain / building / actor proofs.
- A-Z anchors now have prop-first proof candidates without relying on bare letter signs.
- Town and home yard props are small enough to scatter in future Home-area and plaza proofs.

Risks:

- A-M and N-Z manifest place IDs include planned-place granularity that is more specific than current runtime `world_map.memory_anchors` for some letters. Stable `anchor_id`, `letter`, and `core_word` match; only place granularity should be reviewed later.
- These are still generated proof candidates, not approved production sprites or animation-ready assets.

## Decision

Keep Round172 as proof-only composition-kit evidence. Do not map it to runtime until V02.39 target frame / visual-layout approval exists.
