# IPTV Tunerr

IPTV Tunerr turns an IPTV provider or M3U playlist into a stable tuner and
guide source for Plex, Emby, and Jellyfin. It serves an HDHomeRun-compatible
device endpoint, an M3U playlist, and an XMLTV guide, allowing media-server
clients to use one consistent local URL.

The service can refresh channel catalogs and guide data, relay provider
streams, and optionally use FFmpeg to remux or transcode playback. Provider
credentials, guide cache, channel catalog, and operator preferences are stored
in the app's persistent data directory. Cache data can be rebuilt and is not
included in YunoHost backups.

## Network access

The tuner endpoints do not use YunoHost SSO because Plex and other media
servers cannot sign in through an interactive web page. The Nginx route is
therefore restricted to the LAN or VPN CIDRs selected during installation.
The authenticated operator dashboard stays bound to loopback and is not
published through the app's domain.

The media server must be able to reach the selected YunoHost HTTPS domain. Use
split-horizon DNS if the server cannot reach its public domain from inside the
LAN. Do not expose the tuner route to the public internet.

## Workload

Each concurrent stream relays provider traffic in both directions. Network
bandwidth scales with stream bitrate and concurrency. FFmpeg work, recording,
large catalogs, and guide refreshes add CPU, RAM, and storage use. Tunerr has
no measured YunoHost-specific minimum hardware requirement.
