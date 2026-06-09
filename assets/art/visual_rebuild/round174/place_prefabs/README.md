# Round174 Place Prefab Proof Candidates

Status: `proof_only/normalized_candidate`

This folder contains eight cozy town landmark/place prefab candidates generated with the local fallback image generator and normalized into transparent `320x320` PNG cells. They are stored under the asset tree for stable proof references only and are not wired into runtime, `AssetResolver`, `ThemeProfile`, data, or shared tests.

## Contents

- `raw/`: generator outputs at `1024x1024`.
- `normalized_320x320/`: transparent RGBA prefab candidates.
- `proof/round174_place_prefabs_raw_contact.png`: raw generation contact sheet.
- `proof/round174_place_prefabs_normalized_contact.png`: normalized visual contact sheet.
- `proof/round174_place_prefabs_320x320_pivot_proof.png`: baseline and pivot proof.
- `round174_place_prefabs_manifest.json`: prompts, dimensions, pivots, footprints, validation notes, and risks.

## Pivot And Footprints

All normalized assets use cell size `320x320` and recommended pivot `(160, 302)`, matching the Round170 building-prefab convention. Footprints are recommendations only; final collision and placement should be tuned in a later layout/runtime gate.

## Gate Notes

The fallback generator returned RGB raw PNGs, so final transparency was produced through local chroma-key removal. The normalized files passed basic structural checks: eight files, `320x320`, RGBA alpha, transparent corners, and no alpha touching cell edges. Minor chroma-edge residue remains a proof-only risk.
