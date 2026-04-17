# Pi Network Node (Unraid Template)

Unraid Community Applications (CA) template for running the Pi Network Node on Unraid (mainnet), via the BitCryptic wrapper image with performance tuning baked in.

This repo provides:
- An Unraid Docker template XML for `bitcryptic/pi-network-node:v22.1` (wraps `pinetwork/pi-node-docker:organization-mainnet-v1.0-p22.1`)
- Basic setup notes and common troubleshooting tips

## What this template does

- Runs the node in persistent mode by mapping a host path to `/opt/stellar` (required) https://hub.docker.com/r/pinetwork/pi-node-docker
- Exposes the three standard ports used by the node container:
  - 31401 -> 8000 (Horizon HTTP)
  - 31402 -> 31402 (stellar-core peer)
  - 31403 -> 1570 (Local history server / webfsd) https://hub.docker.com/r/pinetwork/pi-node-docker
- Uses container runtime arguments (`--mainnet --enable-auto-migrations`) as *Post Arguments* (so they are passed after the image name), which is required for correct Docker argument ordering.
- Applies performance tuning ENV vars out of the box:
  - `INGEST_DISABLE_STATE_VERIFICATION=true` — disables periodic full ledger state scans (main CPU reduction)
  - `PARALLEL_JOB_SIZE=1` — reduces horizon ingestion worker parallelism
  - `HISTORY_RETENTION_COUNT=1000000` — retains ~8 weeks of ledger history instead of all history since genesis

## Quick start (Unraid)

1. Add the template XML to your Unraid flash drive templates folder (or install via CA once published).
2. Create/choose a persistent appdata path for `/opt/stellar` (example):
   `/mnt/cache/appdata/pi-node-mainnet/stellar`
3. Set `POSTGRES_PASSWORD` (required).
4. (Optional) Set `NODE_PRIVATE_KEY` only if you are migrating an existing node identity.
5. Start the container and wait for initial database setup + migrations to complete.

## Configuration

Pi Docker image docs: https://hub.docker.com/r/pinetwork/pi-node-docker

### POSTGRES_PASSWORD (required)

Database password for the node's Postgres instance (do not share). This must be set. Choose your own.

### NODE_PRIVATE_KEY (optional, advanced: migration only)

Set this only if you are migrating/re-using an existing node identity.
Leave it blank for a brand-new node (the container will auto-generate one if not provided).
Important: Do not run two nodes with the same NODE_PRIVATE_KEY at the same time.

### Back up your node key (recommended for new nodes)

If you start a new node without setting NODE_PRIVATE_KEY, a key/seed is auto-generated.
Retrieve it using one of the methods below, back it up somewhere safe and never share it (treat it like a password).

Method 1 (host side, if mainnet.env exists under your persisted data):

    grep -E '^(NODE_SEED|NODE_PRIVATE_KEY)=' /mnt/cache/appdata/pi-node-mainnet/stellar/mainnet.env

Method 2 (inside the container, from stellar-core.cfg):

    docker exec PiNetworkNode sh -lc "grep -E 'NODE_SEED|NODE_PRIVATE_KEY' /opt/stellar/core/etc/stellar-core.cfg"

## Ports

Only these ports are mapped by this template:
- 31401/tcp
- 31402/tcp
- 31403/tcp

Note: The stellar-core admin port (11626) is intentionally not mapped in this template.

## Support

https://forums.unraid.net/topic/197354-pi-network-node-docker-unraid-template-mainnet/

## Support the Template Maintainer

If this template saved you time, consider buying me a coffee:
https://buymeacoffee.com/bitcryptic

## Disclaimer

This is a community-maintained Unraid template and is not affiliated with Pi Core Team.
"Pi", "Pi Network", and the Pi logo are trademarks of Pi Community Company. This project is community-maintained and not affiliated with or endorsed by Pi.
