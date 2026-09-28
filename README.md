# freecad-fusion

Make [FreeCAD](https://www.freecad.org) feel familiar if you come from **Autodesk Fusion**.
Install it, restart FreeCAD, and the mouse, the view cube and the single-key shortcuts
behave the way your hands already expect. Everything is reversible from the Tools menu.

Tested on FreeCAD 1.1 (macOS). Requires FreeCAD 1.0 or newer.

## What changes

### 1. Drag the NaviCube to orbit
In Fusion you can grab the ViewCube and drag it to rotate the view. In FreeCAD, dragging
the NaviCube moves the widget itself ([FreeCAD#6306](https://github.com/FreeCAD/FreeCAD/issues/6306)).
With this add-on:

- **click and drag** the centre of the cube to orbit (turntable, around the model's Z axis);
- **click** a face, edge or corner to snap to that view, exactly as before;
- the arrows and buttons around the cube keep working as normal.

### 2. Fusion mouse navigation

| Action | Fusion | FreeCAD with this add-on |
|---|---|---|
| Orbit | Shift + middle-drag | Shift + middle-drag |
| Pan | Middle-drag | Middle-drag |
| Zoom | Wheel, towards the cursor | Wheel, towards the cursor |
| Select | Left click | Left click |

This uses FreeCAD's built-in *Revit* navigation style, which has exactly this mapping,
plus *zoom at cursor*.

### 3. Fusion keyboard shortcuts

| Key | Fusion | FreeCAD command |
|---|---|---|
| L | Line | Sketcher: Line |
| R | 2-point rectangle | Sketcher: Rectangle |
| C | Center diameter circle | Sketcher: Circle |
| D | Sketch dimension | Sketcher: Dimension |
| X | Normal / construction | Sketcher: Toggle construction |
| T | Trim | Sketcher: Trim |
| O | Offset | Sketcher: Offset |
| P | Project / include | Sketcher: External projection |
| E | Extrude | Part Design: Pad |
| H | Hole | Part Design: Hole |
| F | Fillet | Part Design: Fillet |
| M | Move / copy | Transform |
| I | Measure | Measure |
| A | Appearance | Appearance |

When a Fusion key was already used by a FreeCAD command (for example `C` for the
coincident constraint or `H` for horizontal), the Fusion meaning wins and the FreeCAD
command's shortcut is saved so it can be restored. The FreeCAD Report view lists what
moved on first start.

## Install

**Addon Manager (recommended):** Edit > Preferences > Addon Manager > *Custom repositories*,
add `https://github.com/arxdsilva/freecad-fusion` with branch `main`, then install
**freecad-fusion** from Tools > Addon Manager and restart FreeCAD.

**macOS / Linux, one line:**

```sh
curl -fsSL https://raw.githubusercontent.com/arxdsilva/freecad-fusion/main/install.sh | bash
```

**Windows (PowerShell), one line:**

```powershell
irm https://raw.githubusercontent.com/arxdsilva/freecad-fusion/main/install.ps1 | iex
```

**From a clone:** `git clone https://github.com/arxdsilva/freecad-fusion && ./freecad-fusion/install.sh`
(or `install.ps1` on Windows). The scripts link the checkout into every FreeCAD user
`Mod` folder they find, so `git pull` updates the add-on.

On the first start after installing, the Fusion navigation and shortcuts are applied
automatically.

## Using and undoing it

Three entries are added to the **Tools** menu in every workbench:

- **Apply Fusion navigation & shortcuts**: apply (or re-apply) the preset;
- **Restore my previous FreeCAD settings**: put back your navigation style and every
  shortcut the preset changed (your own custom shortcuts, or FreeCAD's defaults);
- **Drag NaviCube to orbit**: turn the drag-to-orbit behaviour on or off.

### Tuning

Tools > Edit Parameters > `BaseApp/Preferences/Mod/FreecadFusion`:

| Parameter | Type | Default | Meaning |
|---|---|---|---|
| `NaviCubeDrag` | Boolean | true | Drag-to-orbit on the NaviCube |
| `NaviCubeDragDegPerPx` | Float | 0.5 | Orbit speed, degrees per pixel dragged |
| `NaviCubeDragInvert` | Boolean | false | Reverse the drag direction |

## Uninstall

Run **Tools > Restore my previous FreeCAD settings** first, then remove the add-on in the
Addon Manager, or run `./install.sh --uninstall` / `.\install.ps1 -Uninstall`.

## Limitations

- Only the centre of the NaviCube is draggable; the outer band is left to FreeCAD's own
  arrow and menu buttons.
- FreeCAD has no direct equivalent of Fusion's Press Pull (`Q`), Joint (`J`) or the `S`
  toolbox, so those keys are left alone.
- A key can only run one command, so `M` is global Transform rather than Fusion's
  sketch-only move.

## Roadmap ideas

- Timeline-style history panel on top of the Part Design tree.
- Fusion-style marking menu on right-click.
- A preference page instead of raw parameters.

Contributions are welcome: open an issue or a pull request.

## License

MIT, see [LICENSE](LICENSE).
