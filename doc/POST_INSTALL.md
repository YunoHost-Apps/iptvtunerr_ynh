The tuner endpoint is available at the URL selected during installation. Add
that URL as the tuner device in Plex, Emby, or Jellyfin and use
`<URL>/guide.xml` as the guide URL.

The Nginx route allows only the LAN/VPN networks selected during installation.
If the media server cannot connect, check its source address and update the
trusted-network list in the Nginx access include before widening access.
