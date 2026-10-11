FROM pinetwork/pi-node-docker:organization-mainnet-v1.0-p28.0.1
# Performance tuning for horizon — significantly reduces CPU and IO load on the host.
#
# WHERE THE EFFECTIVE VALUES ACTUALLY COME FROM — read before changing anything here:
# `/opt/stellar/horizon/bin/horizon` runs `source /opt/stellar/horizon/etc/horizon.env`
# before exec'ing the binary, and `source` overrides the container environment. So the
# values horizon really uses are the ones in the PERSISTED appdata copy of horizon.env
# (<appdata>/horizon/etc/horizon.env), NOT the ENV block below. The ENV block is the
# documented intent and the default this image seeds — see the RUN below.
#
# INGEST_DISABLE_STATE_VERIFICATION: disables periodic full ledger state scans (main win).
#   Upstream's stock horizon.env does not set this key, so the container ENV applies.
# HISTORY_RETENTION_COUNT: prunes horizon's history tables to the most recent 125000
#   ledgers. At ~5s per ledger that is about 7 days. Upstream's stock horizon.env ships
#   `export HISTORY_RETENTION_COUNT=0` (retain everything since genesis) and copy_defaults
#   installs that file into appdata on first boot, so the stock 0 used to silently
#   override this ENV on every fresh install — and 0 also disables horizon's
#   lookup-table reaping. The RUN below patches the stock defaults this image ships so
#   that new installs get 125000; an existing appdata directory keeps its own file,
#   because this image never rewrites it.
RUN sed -i 's/^export HISTORY_RETENTION_COUNT=.*/export HISTORY_RETENTION_COUNT=125000/' \
        /opt/stellar-default/common/horizon/etc/horizon.env \
        /opt/stellar-default/pubnet/horizon/etc/horizon.env \
 && grep -q '^export HISTORY_RETENTION_COUNT=125000$' /opt/stellar-default/common/horizon/etc/horizon.env \
 && grep -q '^export HISTORY_RETENTION_COUNT=125000$' /opt/stellar-default/pubnet/horizon/etc/horizon.env

ENV INGEST_DISABLE_STATE_VERIFICATION=true \
    HISTORY_RETENTION_COUNT=125000
