# Home Kindle TRMNL

A KUAL (Kindle Unified Application Launcher) extension that turns your jailbroken Kindle into a [TRMNL](https://trmnl.com/) compliant screen.

> [!TIP]
> You can follow these [amazing instructions](https://kindlemodding.org/jailbreaking/index.html) on how to jailbrake your Kindle using WinterBreak.

## Installation

1. Download this repository.
2. Update the `home-kindle-trmnl/config.conf` file and replace the following:
  - `<api-key>`\
    With the API key you have configured for the device on your TRMNL server. **Most Kindle devices do not support mDNS (multicast DNS), so `.local` domains will fail to resolve.**
  - `<base-url>`\
    The base URL to your TRMNL server.
3. Connect your Kindle device and copy the `home-kindle-trmnl` directory to the `/extensions` directory on your Kindle.

> [!TIP]
> When installing updates, do not copy the `config.conf` file as it will overwrite your configuration.

## Usage

Once installed, when you open KUAL you will see a **Home Kindle TRMNL** extension listed. When you open the extension then you see two menu items:

- **Start Home Kindle TRMNL**\
  This will start Home Kindle TRMNL; if you have already started Home Kindle TRMNL then this will do nothing.
- **Stop Home Kindle TRMNL**\
  This will stop Home Kindle TRMNL if it's currently running.

### Debugging

If you encountering issues, you can enable `debug` mode by updating the `/extensions/home-kindle-trmnl/config.conf` file by setting the `DEBUG` variable to `true`. This will result in logs being written to a file in the `/home-kindle-trmnl/logs` directory on your Kindle; the log files are organized by date.

Furthermore, when you have `debug` mode enabled you can view the current screen image at `/home-kindle-trmnl/screen.png` or `/home-kindle-trmnl/screen.bmp` (depending on the image type your TRMNL server returns).

## FAQ

### Why is the battery level being reported as `0%`?

Kindle's do not report a battery voltage, but a battery percentage, and most TRMNL servers expect the former. This client sets the typically supported `battery-voltage` header to `0` and sends the battery level in a `battery-percentage` header.

### What screen image types are supported?

This client only supports `.png` and `.bmp` for the screen images at the moment.
