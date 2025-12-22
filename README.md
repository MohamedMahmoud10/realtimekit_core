# dyte_core_platform_interface

A common platform interface for the `dyte_core` plugin.

This interface allows platform-specific implementations of the `dyte_core` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `dyte_core`, extend `FlutterCorePlatform` with an implementation that performs the platform-specific behavior.
