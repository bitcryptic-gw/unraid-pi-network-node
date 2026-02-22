# Pi Network Node (Unraid Template)

Unraid Community Applications (CA) template for running the official Pi Network Node Docker image on Unraid (mainnet).

This repo provides:
- An Unraid Docker template XML for `pinetwork/pi-node-docker:organization_mainnet-v1.3-p19.6`
- Basic setup notes and common troubleshooting tips

## What this template does

- Runs the node in persistent mode by mapping a host path to `/opt/stellar` (required) [https://minepi.com/pi-blockchain/pi-node/linux/].
- Exposes the three standard ports used by the node container:
  - 31401 -> 8000 (Horizon HTTP)
  - 31402 -> 31402 (stellar-core peer)
  - 31403 -> 1570 (Local history server / webfsd) [https://minepi.com/pi-blockchain/pi-node/linux/].
- Uses container runtime arguments (`--mainnet --enable-auto-migrations`) as *Post Arguments* (so they are passed after the image name), which is required for correct Docker argument ordering.

## Quick start (Unraid)

1. Add the template XML to your Unraid flash drive templates folder (or install via CA once published).
2. Create/choose a persistent appdata path for `/opt/stellar` (example):
   `/mnt/cache/appdata/pi-node-mainnet/stellar`
3. Set `POSTGRES_PASSWORD` (required).
4. (Optional) Set `NODE_PRIVATE_KEY` only if you are migrating an existing node identity.
5. Start the container and wait for initial database setup + migrations to complete.

## Configuration

### POSTGRES_PASSWORD (required)
Database password for the node’s Postgres instance (do not share). [Pi Docker docs]

### NODE_PRIVATE_KEY (optional, advanced)
Existing node private key (secret seed) to reuse an existing node identity. Leave blank for a new node; the container can auto-generate the key if not provided. [Pi Docker docs]

Important: Do not run two nodes with the same `NODE_PRIVATE_KEY` at the same time.

## Ports

Only these ports are mapped by this template:
- 31401/tcp
- 31402/tcp
- 31403/tcp

Note: The stellar-core admin port (11626) is intentionally not mapped in this template.

## Disclaimer

This is a community-maintained Unraid template and is not affiliated with Pi Core Team.
