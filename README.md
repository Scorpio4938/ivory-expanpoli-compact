# Expanpoli Patch

Ports the Ivory Car Pack siren audio system onto @Expansion Mod - Police vehicles. Supports all 17 EM_* police vehicle classes across 13 d3s model families.

## Dependencies

- [Expansion Mod - Police](https://steamcommunity.com/workshop/filedetails/?id=) *(EM_Police_Faction)*
- [Ivory Car Pack](https://steamcommunity.com/workshop/filedetails/?id=1888644057)
- [CBA](https://steamcommunity.com/workshop/filedetails/?id=450814997)

## Controls

| Key | Action |
|---|---|
| **R** | Siren on / off |
| **Shift+R** | Next siren tone |
| **T** | Lightbar on / off |
| **F** (hold) | Horn |
| **C** (hold) | Takedown tone |
| **1** – **4** | Direct tone select (Wail, Yelp, Priority, HiLo) |
| **\\** | Read Manual |

## What's Patched

- **Siren audio** — 4 Ivory SS2000 tones (Wail, Yelp, Priority, HiLo) via dual-dummy `#particlesource` + `say3D`
- **Horn** — hold-to-play airhorn, cancellable on release
- **Takedown** — hold-to-play priority/wail tone
- **Lightbar toggle** — wired to Expanpoli's native lightbar scripts; off kills siren, on restores it
- **Keybinds** — all controls mapped via CBA (rebindable in game options)
- **Interior audio** — config-level occlusion fix on all 13 d3s base classes makes sirens audible inside the cabin

Expanpoli's original lightbar visuals, Code 1/2/3 scroll-wheel actions, and radar are unaffected.

## Differences from the Mean Patch

This patch is a sibling of [`ivory-mean-compact`](https://github.com/Scorpio4938/ivory-mean-compact) — same architecture, adapted for Expanpoli:

| | Mean Patch | Expanpoli Patch |
|---|---|---|
| Target mod | Means Emergency Vehicle Pack | Expansion Mod - Police |
| Vehicle count | 37 concrete classes | 17 concrete classes |
| Occlusion fix | 6 CRFT_Car_Base children | 13 d3s_*_base children (parent Car_F) |
| Vehicle gate | 6-prefix match | 1-prefix match (`EM_`) |
| Lightbar trigger | `_vcl animate` | Expanpoli's native execVM scripts |
| GetIn handler | 6 base classes | 17 concrete EM_* classes |

## GitHub

<https://github.com/Scorpio4938/ivory-expanpoli-compact>

## Credits

- **Jakes** — Expansion Mod - Police.
- **Ivory** — Ivory Car Pack (siren audio system).
- **CBA Team** — Community Base Addons.

## License

This repo's original code (the `expanpoli-patch` addon) is licensed under the [MIT License](LICENSE). Our code uses and adapts systems from the source mods listed in Credits — please respect their terms as stated above.
