#### [Gogs] Docker image

This image is based on [phusion/baseimage] so it has proper boot sequence and  process supervision.

phusion/baseimage is Ubuntu 14.04 LTS based image with [runit] init, cron, syslog-ng, and [sshd].

Usage:

    docker run -ti --rm \
        -p 50022:22 \
        -p 50443:50443 \
        -v /var/git:/home/git \
        -e DOMAIN=git.domain.com \
        -e SSH_PORT=50022 \
        -e HTTPS_PORT=50443 \
        arkadi/gogs \
        /sbin/my_init -- bash -l

- UI will be on port 50443 (HTTPS).
- The data: Git repositories, HTTPS and SSH keys, Gogs config, etc. will be under /var/git.
- DOMAIN is required for proper Gogs and HTTPS certificate configuration.
- SSH_PORT and HTTPS_PORT are optional, but will default to 50022 and 50443 respectively. Those variables exists to configure links presented by Gogs as part of its UI and in email text.
- `/sbin/my_init -- bash -l` is optional to enter contain with shell at startup.

[Gogs]: http://gogs.io/
[phusion/baseimage]: http://phusion.github.io/baseimage-docker/
[runit]: http://smarden.org/runit/
[sshd]: https://github.com/phusion/baseimage-docker#login-to-the-container-or-running-a-command-inside-it-via-ssh
