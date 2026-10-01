# Administration

## Provider configuration

The package stores optional environment settings in
`/home/yunohost.app/iptvtunerr/iptvtunerr.env`, owned by the app user and mode
0600. Edit this file over SSH, remove the leading `#` from the settings you
use, and restart the service:

```sh
sudo nano /home/yunohost.app/iptvtunerr/iptvtunerr.env
sudo yunohost service restart iptvtunerr
```

Set `IPTV_TUNERR_PROVIDER_URL`, `IPTV_TUNERR_PROVIDER_USER`, and
`IPTV_TUNERR_PROVIDER_PASS` for an Xtream-style provider, or set
`IPTV_TUNERR_M3U_URL` for an M3U feed. These settings can contain provider
credentials; keep the file private. Optional Plex registration and API-Sports
settings are also listed in the file.

The base URL used by the tuner is stored as the YunoHost app setting
`base_url`. It defaults to `https://<selected-domain>` and should remain the
HTTPS URL of the selected YunoHost domain, without a path or port. If Plex
cannot resolve or reach it from the trusted network, configure split-horizon
DNS so that domain resolves to the YunoHost host inside the LAN or VPN. The
package's change-URL action updates both Nginx and the systemd service.

## Operator dashboard

The authenticated operator dashboard listens on `127.0.0.1:48879` and is not
published through the YunoHost domain. To access it remotely, create an SSH
tunnel from the administrator's workstation:

```sh
ssh -L 48879:127.0.0.1:48879 administrator@yunohost-host
```

Then open `http://127.0.0.1:48879/`. The default dashboard password is
generated at service startup and appears once in the service log. For a
stable password, set `IPTV_TUNERR_WEBUI_USER` and `IPTV_TUNERR_WEBUI_PASS` in
the private environment file and restart the service.

## Trusted-network rules

During installation, the package writes validated CIDR entries to
`/var/www/iptvtunerr/network-access.conf`. The Nginx vhost includes this file
before proxying any tuner route. Update the include with only the media-server
LAN or VPN ranges that should reach the service, then reload Nginx:

```sh
sudo nano /var/www/iptvtunerr/network-access.conf
sudo yunohost service reload nginx
```

Do not add `0.0.0.0/0` or `::/0`; the tuner and operator APIs are intended for
trusted media-server networks, not direct public access.

## Data and backups

The catalog, operator state, private environment file, and logs live in
`/home/yunohost.app/iptvtunerr`. Guide/provider cache data is stored below its
`cache` directory and omitted from YunoHost backups because it can be rebuilt.
Provider settings and catalog state are included in backups.
