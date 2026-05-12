# opencode-remote

Small installable launcher for running OpenCode server + OpenChamber together.

It is useful when you want to start coding on one machine and then attach from a phone or another workstation over your network/VPN.

## Requirements

- `opencode` on PATH
- `openchamber` on PATH
- `node`, `curl`, and `bash`

## Install

Quick install (no clone):

```bash
curl -fsSL https://raw.githubusercontent.com/badfun/opencode-remote/main/install.sh | bash
```

Install from a local clone:

```bash
git clone <your-repo-url>
cd opencode-remote
bash install.sh
```

The installer creates:

- `~/.local/bin/opencode-remote` (symlink to `bin/opencode-remote`)
- `~/.config/opencode-remote/env` (from template, if missing)

## Configure

Edit `~/.config/opencode-remote/env` and set:

- `OPENCODE_SERVER_PASSWORD`
- `OPENCHAMBER_UI_PASSWORD`

Optional settings:

- `OPENCODE_HOST` (default `http://127.0.0.1:4096`)
- `OPENCHAMBER_HOST` (default `0.0.0.0`)
- `OPENCHAMBER_PORT` (default `3000`)

## Usage

```bash
cd ~/projects/your-project
opencode-remote all
opencode-remote attach
opencode-remote stop-all
```

Other commands:

- `opencode-remote server`
- `opencode-remote ui`
- `opencode-remote ui-fg`
- `opencode-remote stop-server`
- `opencode-remote stop-ui`
- `opencode-remote status`

## Remote phone/workstation usage

After `opencode-remote all`, OpenChamber is available on `OPENCHAMBER_HOST:OPENCHAMBER_PORT` (defaults to `0.0.0.0:3000`).

- On the same machine, open `http://127.0.0.1:3000`
- From a phone or remote workstation, open `http://<machine-ip>:3000`

If you already use a notification tool such as `ntfy`, you can send yourself a ping when the environment is ready, then open OpenChamber from your phone using that machine IP.

For security, prefer private network access (for example Tailscale/WireGuard/LAN) rather than exposing port `3000` publicly.

## Uninstall

```bash
bash uninstall.sh
```
