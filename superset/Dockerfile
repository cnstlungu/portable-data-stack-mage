FROM apache/superset:3.1.3 

ARG SUPERSET_ADMIN
ARG SUPERSET_PASSWORD
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG SUPERSET_SECRET_KEY
# Switching to root to install the required packages
USER root

ADD --chmod=755 https://astral.sh/uv/install.sh /install.sh
RUN /install.sh && rm /install.sh

COPY --chown=superset:superset ./superset/assets .
RUN /root/.cargo/bin/uv pip install --system duckdb-engine==0.13.5 duckdb==1.1.3
USER superset
RUN superset fab create-admin \
              --username ${SUPERSET_ADMIN} \
              --firstname Superset \
              --lastname Admin \
              --email admin@example.com \
              --password ${SUPERSET_PASSWORD}
RUN superset db upgrade
RUN superset init
RUN superset set_database_uri -d DW  -u duckdb:///superset_home/db/datamart.duckdb
RUN superset import-dashboards -p ./dashboard.zip -u ${SUPERSET_ADMIN}