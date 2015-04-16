define_upgrade do
  if Partybus.config.bootstrap_server
    must_be_data_master
    run_sqitch("policyfile-api-tables", "@1.0.4")

    # Make sure API is down
    stop_services(["nginx", "opscode-erchef"])

    force_restart_service("opscode-chef-mover")

    log "Creating default permissions for policyfile endpoints..."
    run_command("/opt/opscode/embedded/bin/escript " \
                "/opt/opscode/embedded/service/opscode-chef-mover/scripts/migrate " \
                "mover_policies_containers_creation_callback normal")

    stop_services(["opscode-chef-mover"])
  end
end

