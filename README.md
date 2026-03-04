# Home Kindle TRMNL

A KUAL (Kindle Unified Application Launcher) extension that turns your jailbroken Kindle into a [TRMNL](https://trmnl.com/) compliant screen.

> [!TIP]
> You can follow these [amazing instructions](https://kindlemodding.org/jailbreaking/index.html) on how to jailbrake your Kindle using WinterBreak.

## Installation

1. Download this repository.
2. Update the `home-kindle-trmnl/trmnl-client.sh` script and replace the following:
  - `<api-key>`\
    With the API key you have configured for the device on your TRMNL server.
  - `<base-url>`\
    The base URL to your TRMNL server.
3. Connect your Kindle device and copy the `home-kindle-trmnl` directory to the `/extensions` directory on your Kindle.

## Usage

Once installed, when you open KUAL you will see a **Home Kindle TRMNL** extension listed. When you open the extension then you see two menu items:

- **Start Home Kindle TRMNL**\
  This will start Home Kindle TRMNL; if you have already started Home Kindle TRMNL then this will do nothing.
- **Stop Home Kindle TRMNL**\
  This will stop Home Kindle TRMNL if it's currently running.

### Debugging

If you encountering issues, you can enable `debug` mode by updating the `trmnl-client.sh` by setting the `DEBUG` variable to `true`. This will result in logs being written to a file in the `/home-kindle-trmnl/logs` directory; the log file are organized by date.
