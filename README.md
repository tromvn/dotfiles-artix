# dotfiles-artix

Configuración de escritorio para **Artix Linux + OpenRC**, usando **awesome** como gestor de ventanas.

Basado en [Manas140/dotfiles (AweDots)](https://github.com/Manas140/dotfiles), con modificaciones sustanciales: migración de polling a arquitectura basada en eventos D-Bus, nuevo sistema de notificaciones de batería, dashboard extendido, y varios fixes de estabilidad específicos para OpenRC + elogind.

## Crédito

Este repositorio parte de la base visual y estructural de [AweDots](https://github.com/Manas140/dotfiles) de Manas140. Gran parte del sistema de paneles, dashboard y widgets viene de ahí. Las modificaciones propias se centran en estabilidad, rendimiento y adaptación a OpenRC.

## Stack del sistema

- **Distro:** Artix Linux
- **Init:** OpenRC (no systemd, no s6)
- **Kernel:** linux-zen
- **WM:** awesome (X11)
- **Display manager:** greetd + tuigreet
- **Gestión de sesión:** elogind
- **Audio:** PipeWire (con capa de compatibilidad PulseAudio)
- **Terminal:** kitty
- **Shell:** bash

## Prerequisitos

Instala los paquetes base con pacman:

```bash
sudo pacman -S awesome greetd elogind pipewire pipewire-pulse wireplumber \
  bluez bluez-utils networkmanager brightnessctl pulsemixer \
  maim satty flameshot redshift picom rofi xsettingsd \
  kitty mpd mpDris2
```

> **Nota sobre servicios OpenRC:** en Artix, algunos paquetes NO incluyen automáticamente su script de arranque para OpenRC — este va en un paquete separado, generalmente con el sufijo `-openrc`. Si al hacer `rc-service <nombre> start` obtienes un error de que el servicio no existe, busca su contraparte:
>
> ```bash
> paru -Ss <nombre-del-paquete>-openrc
> ```
>
> Esto aplica frecuentemente a `elogind`, `bluez`, `networkmanager` y similares. Instálalo antes de intentar habilitar el servicio.

Vía AUR (usando `paru`):

```bash
paru -S tuigreet xdg-desktop-portal-lxqt
```

Dependencias de Lua (via luarocks o el gestor de tu distro):

```bash
sudo pacman -S lua-lgi
```

## Instalación

**1. Clona el repositorio con submodules:**

```bash
git clone --recurse-submodules https://github.com/tromvn/dotfiles-artix.git
cd dotfiles-artix
```

Si ya lo clonaste sin `--recurse-submodules`:

```bash
git submodule update --init --recursive
```

**2. Copia la configuración de awesome:**

```bash
cp -r awesome ~/.config/awesome
```

**3. Habilita los servicios necesarios:**

```bash
sudo rc-update add greetd default
sudo rc-update add elogind default
sudo rc-update add bluetoothd default
sudo rc-update add NetworkManager default
sudo rc-update add dbus default
```

**4. Configura greetd** (`/etc/greetd/config.toml`):

```toml
[terminal]
vt = 7

[default_session]
command = "tuigreet --cmd startx --time --remember --asterisks"
user = "greeter"
```

**5. Crea tu `~/.xinitrc`:**

```sh
#!/bin/sh
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi
setxkbmap latam   # ajusta a tu layout de teclado
pipewire &
pipewire-pulse &
wireplumber &
blueman-applet &
sleep 1
exec awesome
```

**6. Script de captura de crashes (opcional pero recomendado):**

```bash
mkdir -p ~/crash-logs
cp crash-logs/capture.sh ~/crash-logs/
chmod +x ~/crash-logs/capture.sh
```

Agrega al final de tu `.xinitrc`, justo después de `exec awesome`, una trampa que lo ejecute al terminar la sesión (ver sección de notas post-instalación para el porqué).

## Notas importantes post-instalación

Estos ajustes no se automatizan con la copia de archivos — hay que hacerlos manualmente una vez:

**Permisos para logs sin sudo** (necesario para el script de captura de crashes):

```bash
sudo usermod -aG log "$USER"
echo "kernel.dmesg_restrict=0" | sudo tee /etc/sysctl.d/99-dmesg.conf
```

Cierra sesión y vuelve a entrar para que el cambio de grupo tome efecto.

**syslog:** Artix con OpenRC no trae syslog por defecto. Sin él, `/var/log/messages` no existe.

```bash
paru -S syslog-ng
sudo rc-service syslog-ng start
sudo rc-update add syslog-ng default
```

En `/etc/syslog-ng/syslog-ng.conf`, descomenta la línea `destination(d_local);` dentro del bloque de log por defecto.

**Apagado seguro por batería crítica:** en `/etc/UPower/UPower.conf`:

```ini
CriticalPowerAction=PowerOff
```

(el valor por defecto `Auto` intenta HybridSleep, que falla silenciosamente si no tienes suficiente swap para hibernar, y termina en apagado abrupto sin guardar nada).

**Sensor de temperatura:** el sensor `thermal_zone0` no es confiable en todos los equipos (puede reportar un valor fijo incorrecto). Verifica cuál corresponde a tu CPU real:

```bash
sensors
for z in /sys/class/thermal/thermal_zone*/temp; do echo "$z: $(cat $z)"; done
```

Compara los valores con la salida de `sensors` (busca `coretemp`) y ajusta la ruta en `awesome/signals.lua` si es necesario.

**Capturas de pantalla:** flameshot v14 (Qt6) tiene un bug conocido que hace timeout indefinido en X11 sin compositor ([issue en GitHub](https://github.com/flameshot-org/flameshot/issues/4639)). Esta config usa `maim + satty` como alternativa (atajo `Print`). El script antiguo con flameshot se dejó en `awesome/utilities/screensht` por si el bug se resuelve en el futuro y prefieres volver a él.

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `Print` | Captura de pantalla (maim + satty) |
| `Super + Return` | Terminal |
| `Super + r` | Rofi (launcher) |
| `Super + d` | Abrir/cerrar dashboard |
| `Super + q` | Cerrar ventana enfocada |
| `Super + Ctrl + q` | Cerrar sesión de awesome |
| `Alt + Tab` | Cambiar entre ventanas |
| `Super + [1-8]` | Ir a la tag N |
| `Super + Shift + [1-8]` | Mover ventana a la tag N |
| `XF86MonBrightnessUp/Down` | Brillo |
| `XF86AudioRaiseVolume/LowerVolume/Mute` | Volumen |

## Optimización de hardware

Ajustes aplicados en este equipo (Dell Inspiron 3501, i5-1135G7, 15GB RAM) para mejorar rendimiento y capacidad de respuesta:

**Kernel linux-zen:** incluye parches orientados a escritorio/interactividad (scheduler más agresivo priorizando procesos en primer plano) frente al kernel estándar. Instalación:

```bash
sudo pacman -S linux-zen linux-zen-headers
```

Actualiza tu bootloader (GRUB/systemd-boot/rEFInd) para incluir la nueva entrada y selecciónala al reiniciar.

**zram:** memoria swap comprimida en RAM, más rápida que swap en disco para picos de uso de memoria. **No sirve para hibernación** (es RAM, no almacenamiento persistente) — si necesitas hibernar, usa una partición o archivo swap real dimensionado igual o mayor a tu RAM total.

```bash
sudo pacman -S zram-generator
```

Configuración usada (`/etc/zram-generator.conf` o equivalente para tu gestor de zram):

```ini
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
```

**Consideración sobre polling vs eventos:** si vas a extender esta configuración con nuevos widgets de estado (batería, red, dispositivos), prioriza escuchar señales D-Bus o usar comandos de larga duración con `awful.spawn.with_line_callback` en lugar de temporizadores que relanzan procesos cada N segundos. El polling agresivo de D-Bus (especialmente hacia BlueZ) fue la causa raíz de caídas de sesión intermitentes en este equipo — ver `awesome/signal/` para los patrones ya implementados (bluetooth, volumen, brillo, red).

## Problemas conocidos

- El indicador de bluetooth en la wibar puede no aparecer al iniciar sesión hasta desactivar/activar bluetooth una vez manualmente (bug en investigación).
- Los sliders de volumen no siempre reflejan cambios hechos con las teclas de atajo de multimedia (bug en investigación).
- Satty y algunas apps GTK4 no siempre respetan el tema oscuro configurado vía lxappearance.

## Mejoras futuras

- [ ] Calendario expandible en el widget de bienvenida del dashboard
- [ ] Selector de dispositivo de micrófono (interno / auriculares bluetooth) desde el dashboard
- [ ] Enrutamiento de audio por aplicación (parlante para música, auriculares para llamadas)
- [ ] Dashboard debe abrirse en el monitor donde está el cursor/tag activa, no siempre en el monitor externo
- [ ] Diagnosticar por qué el indicador de bluetooth en la wibar no aparece por defecto al iniciar sesión
- [ ] Diagnosticar por qué el slider de volumen no se actualiza al usar las teclas de atajo
- [ ] Reposicionar wibar arriba con nuevo orden de widgets (buscador → tag activa → aplicaciones → captura → indicadores → hora)
- [ ] Formato de hora a 24h
- [ ] Arreglar Ranger en el menú del escritorio
- [ ] Agregar Impala (TUI de wifi) y un TUI de gestión de bluetooth al menú
- [ ] Resolver inconsistencia de tema GTK (satty y otras apps no toman el tema oscuro)
- [ ] Resolver inconsistencia del cursor del sistema (solo se aplica en escritorio vacío)
- [ ] Integrar `crash-logs/capture.sh` en `.xinitrc` para captura automática al cerrar sesión
- [ ] Investigar segundo tipo de crash de sesión sin causa determinada (logout limpio sin errores en logs)
