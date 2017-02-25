FROM local/c7-systemd
MAINTAINER "Aidan Harris" <mail@aidanharris.io>

# The `|| true` is to avoid errors from System D being unavailable during build since there is no `--privileged` flag for `docker build` - DO NOT REMOVE THIS
RUN yum update -y && \
    yum install -y curl && \
    mkdir -p /srv/salt && \
    mkdir -p /srv/formulas && \
    curl -L https://bootstrap.saltstack.com | sh || true && \
    yum clean all

ADD minion /etc/salt/minion

# Since we have no way to know if the salt installation succeeded (because of the `|| true`) this checks that everything is working okay...
# Feel free to remove this if you're feeling lucky and want to save a tiny amount of disk space in the image
RUN salt-call test.ping

CMD ["/usr/sbin/init"]
