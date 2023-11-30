FROM ruby:3.2.2

# Parent service ports, 4000: Jekyll server, 35729: Live reload server
EXPOSE 4000 35729

# Arguments should be passed from command line, the default values are
# for reference only.
ARG TIMEZONE=Etc/UTC
ARG USERNAME=app
ARG USER_UID=1000
ARG USER_GID=1000

# Start as root user
USER root

# - Install development tools
# - Install specific versions of bundler and jekyll
# - Set timezone
RUN apt-get update && apt-get install -y vim sudo \
    && gem install bundler:2.4.21 jekyll:3.9.3 \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE:?missing} /etc/localtime

# Create a non-group user with root privileges.
# This user should match the host user to avoid permission issues.
# Reference: https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
        --shell /bin/bash --no-log-init \
    #
    # Add sudo support
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install dependencies for the new user
USER $USERNAME
WORKDIR /app
COPY --chown=${USERNAME} Gemfile Gemfile.lock ./
RUN bundle config set --local path ~/.local/share/gem \
    && bundle install

COPY . .

# Unset entrypoint and cmd
ENTRYPOINT []
CMD []
