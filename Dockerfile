FROM pinetwork/pi-node-docker:organization-mainnet-v1.0-p21.2

# Performance tuning for horizon — significantly reduces CPU load on the host.
# INGEST_DISABLE_STATE_VERIFICATION: disables periodic full ledger state scans (main win).
# PARALLEL_JOB_SIZE: reduces ingestion worker parallelism.
# HISTORY_RETENTION_COUNT: keeps ~8 weeks of ledgers (~1M at ~5s each) instead of all history.
RUN echo 'export INGEST_DISABLE_STATE_VERIFICATION=true' >> /opt/stellar/horizon/etc/horizon.env && \
    echo 'export PARALLEL_JOB_SIZE=1' >> /opt/stellar/horizon/etc/horizon.env && \
    echo 'export HISTORY_RETENTION_COUNT=1000000' >> /opt/stellar/horizon/etc/horizon.env
