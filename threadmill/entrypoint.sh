#!/usr/bin/env bash
mlaunch init --dir ~/mdb --setParameter enableTestCommands=1 --setParameter diagnosticDataCollectionEnabled=false --replicaset --name test-rs --nodes 2 --arbiter

bundle exec foreman start
