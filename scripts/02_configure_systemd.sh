#!/usr/bin/env bash
set -e
echo "[SolukOS] Systemd ve sulogin yapılandırması uygulanıyor..."
source ./config/solukos.conf

if [ "${SYSTEMD_SULOGIN_FORCE}" = "1" ]; then
    echo "[SolukOS] SYSTEMD_SULOGIN_FORCE etkinleştirildi."
    mkdir -p "${WORK_DIR}/chroot/etc/systemd/system/emergency.service.d"
    mkdir -p "${WORK_DIR}/chroot/etc/systemd/system/rescue.service.d"
    cat << 'CONF_EOF' > "${WORK_DIR}/chroot/etc/systemd/system/emergency.service.d/override.conf"
[Service]
Environment=SYSTEMD_SULOGIN_FORCE=1
ExecStart=
ExecStart=-/usr/lib/systemd/systemd-sulogin-shell emergency
CONF_EOF
    cp "${WORK_DIR}/chroot/etc/systemd/system/emergency.service.d/override.conf" "${WORK_DIR}/chroot/etc/systemd/system/rescue.service.d/override.conf"
fi
