# Round179 Home Decor Surfaces Proof Pack

Proof-only candidate pack for future cozy home decoration surfaces. This pack intentionally has no runtime wiring, ThemeProfile entry, AssetResolver mapping, data changes, `art_target_locked`, or `runtime_visual_match`.

The generator creates 12 child-safe PNG candidates with no text, classroom/test motifs, or hard grid styling. Opaque surface swatches are recorded as intentional opaque surfaces. Overlay-like assets are emitted as RGBA PNGs and validated for real transparent pixels per LESSON-022.

Run:

```bash
python3 assets/art/visual_rebuild/round179/home_decor_surfaces/generate_validate_pack.py
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round179/home_decor_surfaces
```

Main proof:

`assets/art/visual_rebuild/round179/home_decor_surfaces/proof/round179_home_decor_surfaces_contact_sheet.png`
