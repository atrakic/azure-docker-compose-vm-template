# syntax=docker/dockerfile:1
ARG OLAMA_TAG=latest

FROM ollama/ollama:${OLAMA_TAG}

COPY --chmod=0755 entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
