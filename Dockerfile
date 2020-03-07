ARG VARIANT_VERSION=0.35.1
ARG YQ_VERSION=2.4.0

FROM aroq/variant:$VARIANT_VERSION as variant
FROM mikefarah/yq:$YQ_VERSION as yq

FROM aroq/toolbox-wrap:0.1.8
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=variant /usr/bin/variant /usr/bin/

# Install alpine package manifest
COPY Dockerfile.packages.txt /etc/apk/packages.txt
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

RUN mkdir -p /toolbox/toolbox-variant
COPY variant-lib /toolbox/toolbox-variant/
COPY templates /toolbox/toolbox-variant/

COPY /entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
