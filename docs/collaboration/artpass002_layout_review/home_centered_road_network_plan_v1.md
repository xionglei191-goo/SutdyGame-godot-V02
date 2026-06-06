# Home-Centered Road Network Plan V1

> Status: review proposal only. Not applied to runtime JSON.
> Base layout: `sunshine_town_world_layout_home_centered_proposal_v4`.

## Planning Goal

Home is the world center. Every daily route should feel like leaving home and safely returning home, not like crossing a distant map.

The road network should reserve visible walking space for player movement, landmarks, trees, signs, future building art, touch targets, and camera framing.

## Road Hubs

| Hub ID | Name | Role |
|---|---|---|
| H0 | Home Plaza Hub | Main return point and route hub |
| H1 | Morning Fork | Split between school road and story bridge |
| H2 | School Gate Hub | School entry and safe morning arrival |
| H3 | Story Bridge Hub | Quiet bridge between school return and home |
| H4 | Shop Street Gate | Entry to upper-right daily shop branch |
| H5 | Animal Park Gate | Entry to lower-right animal park branch |
| H6 | Coast Preview Gate | Optional beach / coast edge entry |
| H7 | Sun Viewpoint | Visual morning landmark |

## Road IDs

| Road ID | Name | Priority | Path Logic | Notes |
|---|---|---|---|---|
| R0 | Home Plaza Ring | P0 local | A / C / W / T / D around H0 | Short loop inside home; keeps the child oriented around home |
| R1 | Morning School Road | P0 main | Home -> Morning Fork -> School -> Sun | Emotional main road: go to school while facing the morning sun |
| R2 | School Yard Loop | P0 local | G / K / N / R / Y | Safe play loop; no classroom, test, score, or lateness pressure |
| R3 | Story Bridge Lane | P1 quiet bridge | School return -> B / Q / V -> Home | Story and culture connect school and home, not a remote district |
| R4 | Shop Street Branch | P1 daily branch | Home -> H / I / O / J | Daily errands branch; does not block school route |
| R5 | Animal Park Branch | P1 daily branch | Home -> E / F / L / Z / P / M | Animal and zoo landmarks share one coherent park loop |
| R6 | Coast Preview Spur | P2 optional | Z -> U / X | Beach/coast preview only; no daily requirement |
| R7 | Home-Shop Service Path | Secondary | T -> Shop Street Gate | Short driveway-to-shop connector |
| R8 | Home-Animal Garden Path | Secondary | T -> Animal Park Gate | Gentle garden path from home to animal park |

## Acceptance Notes

- Home must remain the visual and navigation center.
- R1 must stay readable as the main Home-to-School morning road.
- Story/Culture should bridge School and Home instead of becoming a remote plaza.
- Shop Street and Animal Park should branch from Home without crowding the main road.
- U/X Coast Edge must remain optional and should not be used by P0 daily content.
- Final art should keep road lanes wider than anchor objects, with clear empty space around intersections.

## Child Safety Boundaries

- Do not add countdowns, lateness, tests, scores, correctness, or mandatory route completion.
- Do not make the coast edge feel like independent travel or a destination the child must reach alone.
- Do not turn School Gate into a locked gate, qualification check, or classroom entry pressure.
- Do not make Shop Street require purchase to continue.
