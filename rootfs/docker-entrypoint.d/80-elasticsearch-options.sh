#!/bin/bash -e

### ES_OPTS ####################################################################

if [ -n "${DOCKER_CONTAINER_START}" ]; then
  declare -a ES_OPTS
  while IFS="=" read -r KEY VAL; do
    if [ ! -z "${VAL}" ]; then
      ES_OPTS+=("-E${KEY}=${VAL}")
    fi
  done < <(env | egrep "^[a-z_]+\.[a-z_]+" | sort)
  set -- $@ ${ES_OPTS[@]}
  unset ES_OPTS
fi

### ES_JAVA_OPTS ###############################################################

# The virtual file /proc/self/cgroup should list the current cgroup
# membership. For each hierarchy, you can follow the cgroup path from
# this file to the cgroup filesystem (usually /sys/fs/cgroup/) and
# introspect the statistics for the cgroup for the given
# hierarchy. Alas, Docker breaks this by mounting the container
# statistics at the root while leaving the cgroup paths as the actual
# paths. Therefore, Elasticsearch provides a mechanism to override
# reading the cgroup path from /proc/self/cgroup and instead uses the
# cgroup path defined the JVM system property
# es.cgroups.hierarchy.override. Therefore, we set this value here so
# that cgroup statistics are available for the container this process
# will run in.
export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"

### ES_PATH ####################################################################

# Set permissions
chown -R ${DOCKER_USER}:${DOCKER_GROUP} ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}
chmod -R u=rwX,g=rX,o-rwx ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}

# Export Elasticsearch settings directory
export ES_PATH_CONF

################################################################################
