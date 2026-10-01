IPTV Tunerr requires the root path of a dedicated domain. The package does not
support an installation below a URL prefix.

The installer asks which LAN or VPN IP networks may reach the tuner. Plex,
Emby, or Jellyfin must connect from one of those networks. YunoHost SSO is
disabled for this package because media-server clients cannot sign in through
an interactive login page.

Use a stable Ethernet-connected host when possible. Each concurrent stream
uses network bandwidth in both directions. Optional ffmpeg remuxing or
transcoding and recording add CPU and disk load; this package has no
Tunerr-specific minimum hardware measurement.
