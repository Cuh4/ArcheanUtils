![In-Game Screenshot](imgs/1.png)

<div align="center">
    <img src="https://img.shields.io/badge/Archean-grey?style=for-the-badge">
    <img src="https://img.shields.io/badge/XenonCode-%232C2D72.svg?style=for-the-badge&logoColor=white">
    <img src="https://img.shields.io/badge/Utilities-9e6244?style=for-the-badge">
</div>

## 📚 Overview
A repo containing all of the utility scripts I've made for Archean with XenonCode. They mostly follow OOP.

For XenonCode linting in VSCode with the extension, you'll need [this](https://github.com/batcholi/XenonCode/raw/master/build/xenoncode.exe). More information can be found at the XenonCode [docs](https://wiki.archean.space/xenoncode/documentation.html#testing-xenoncode).

## 📑 Libraries
### HUD
N/A

### Vehicle
- `battery.xc` A library for reading the battery component in an OOP manner. Alias only, no IO port support.
- `door.xc` A library for making doors using pivots and dashboards. This was made for a truck I made and this likely won't be useful to you as a result.  Aliases only, no IO port support.
- `light.xc` A library for interacting with lights in an OOP manner. Alias only, no IO port support.
- `pump.xc` A library for manipulating pumps in an OOP manner. Alias only, no IO port support.
- `seat.xc` A library for reading seats in an OOP manner. Alias only, no IO port support.
- `thruster.xc` A library for interacting with and reading thrusters in an OOP manner. Alias only, no IO port support.
- `wheel.xc` A library for interacting with and reading wheels in an OOP manner. Alias only, no IO port support.
- `dashboard.xc` A library for interacting with dashboards and reading button presses, etc. Alias only, no IO port support.
- `gyro.xc` A library for interacting with gyroscopes. Alias only, no IO port support.
- `nav-instrument.xc` A library for interacting with the Nav Instrument component. Alias only, no IO port support.
- `beacon.xc` A library for interacting with the Beacon component. It is not possible to set the beacon frequency as text via this library. Alias only, no IO port support.
- `beacon-locator.xc` A library for displaying beacon positions onto a transparent HUD. **Requires `vehicle/beacon.xc`**
- `propeller.xc` A library for interacting with the propeller component in an OOP manner. Alias only, no IO port support.
- `RCS-controller.xc` An **incredibly** useful library for controlling multiple RCS components. Comes with auto-stabilization, configuration, and easy setup. Tuning may be required. Aliases only, no IO port support.
- `docking-port.xc` A library for interacting with the docking port component. Alias only, no IO port support.
- `signature.xc` A library for broadcasting information about your vehicle along with custom data in a standardized format. **Requires `vehicle/beacon.xc`**
- `stalker.xc` A library for easily scanning frequencies using multiple beacons. Aliases only, no IO port support.
- `widgets.xc` A bunch of pre-made widgets you can draw to a screen via a simple function call. Dashboard screens only.
- `buzzer.xc` A library for interacting with the buzzer component. Alias only, no IO port support.
- `TEProtocol_Server.xc` A library for setting up a TEP server and listening for requests. Allows communication with multiple clients (one-way, but responses can be returned like HTTP) with one beacon on one frequency. Essentially HTTP in Archean (to an extent). **Requires `vehicle/beacon.xc`**, `vehicle/TEProtocol_Classes.xc`, `vehicle/TEProtocol_Shared.xc`
- `TEProtocol_Client.xc` A library for sending requests to a TEP server. **Requires `vehicle/beacon.xc`**, `vehicle/TEProtocol_Classes.xc`, `vehicle/TEProtocol_Shared.xc`
- `TEProtocol_Classes.xc` A library required by `TEProtocol_Server.xc` and `TEProtocol_Client.xc`.
- `TEProtocol_Shared.xc` A library required by `TEProtocol_Server.xc` and `TEProtocol_Client.xc`.
- `turret.xc` A library to easily setup and control a turret with pivots, a beacon, and a nav instrument.

### Shared (HUD + Vehicle)
- `PID.xc` A library containing a single function for running a PID. Taken from the XenonCode nodes system.
- `text.xc` A library that adds much needed text utility functions.
- `time.xc` A library for messing with timestamps.
- `toggle.xc` A library for easily converting pulse signals (eg: a dashboard button) to a toggle.
- `pulse.xc` A library for easily converting toggle signals (eg: a seat button) to a pulse
- `logging.xc` A library for sending neatly formatted logs via `print()`.
- `KVArray.xc` A library for creating arrays using key-value pairs. Unlike the built-in arrays, these can be passed into functions, created on the fly, etc. This also means arrays can be passed through beacons.
- `tertiary.xc` A library containing functions with the same behaviour as a tertiary operator.

## ✨ Credit
- [Cuh4](https://github.com/Cuh4)