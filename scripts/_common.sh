#!/bin/bash

source /usr/share/yunohost/helpers

iptvtunerr_seed_environment() {
	local env_file="$data_dir/iptvtunerr.env"

	if [[ -L "$env_file" ]]; then
		ynh_die --message="Refusing to write IPTV Tunerr settings through a symlink."
	fi
	if [[ -e "$env_file" && ! -f "$env_file" ]]; then
		ynh_die --message="IPTV Tunerr environment path exists but is not a regular file."
	fi
	if [[ ! -e "$env_file" ]]; then
		install -o "$app" -g "$app" -m 0600 /dev/null "$env_file"
		cat > "$env_file" <<'EOF'
# Optional provider configuration. Remove the leading # and set only the
# values you use, then restart the iptvtunerr service.
# IPTV_TUNERR_PROVIDER_URL=https://provider.example
# IPTV_TUNERR_PROVIDER_USER=
# IPTV_TUNERR_PROVIDER_PASS=
# IPTV_TUNERR_M3U_URL=
# IPTV_TUNERR_API_SPORTS_KEY=
# IPTV_TUNERR_PMS_URL=http://127.0.0.1:32400
# IPTV_TUNERR_PMS_TOKEN=
# IPTV_TUNERR_WEBUI_USER=admin
# IPTV_TUNERR_WEBUI_PASS=
EOF
	fi
	chown "$app:$app" "$env_file"
	chmod 0600 "$env_file"
}

iptvtunerr_render_network_access() {
	local network_list="${1:-$(ynh_app_setting_get --key=trusted_networks)}"
	local output="$install_dir/network-access.conf"
	local temporary="$install_dir/network-access.conf.tmp"

	if [[ -z "$network_list" ]]; then
		ynh_die --message="At least one trusted LAN or VPN network is required."
	fi

	if ! python3 - "$network_list" > "$temporary" <<'PY'
import ipaddress
import sys

raw = sys.argv[1]
entries = [value.strip() for value in raw.replace("\n", ",").split(",") if value.strip()]
if not entries:
    raise SystemExit("No trusted network entries were provided")
for value in entries:
    network = ipaddress.ip_network(value, strict=False)
    if network.prefixlen == 0:
        raise SystemExit("Public catch-all networks are not allowed")
    print(f"allow {network};")
print("deny all;")
PY
	then
		rm -f "$temporary"
		ynh_die --message="Trusted networks must be valid IP addresses or CIDR ranges, and cannot be a public catch-all."
	fi

	chown root:root "$temporary"
	chmod 0644 "$temporary"
	mv -f "$temporary" "$output"
}

iptvtunerr_prepare_service() {
	install -d -o "$app" -g "$app" -m 0700 "$data_dir" "$data_dir/cache"
	iptvtunerr_seed_environment
	iptvtunerr_render_network_access
	ynh_config_add_nginx
	ynh_config_add_systemd
}

iptvtunerr_register_service() {
	yunohost service add "$app" \
		--description="IPTV Tunerr IPTV tuner and guide bridge" \
		--log="$data_dir/iptvtunerr.log"
}
