module "mq" {
  source = "./modules/mq"

  count = local.create_mq ? 1 : 0

  broker_name        = local.broker_name
  engine_type        = local.engine_type
  engine_version     = local.engine_version
  host_instance_type = local.host_instance_type
  subnet_ids         = local.subnet_ids_mq
  deployment_mode    = local.deployment_mode
  username           = local.username_mq
  apply_immediately  = local.apply_immediately_mq

  logs = [
    {
      general = true
    }
  ]
  maintenance_window_start_time = [
    {
      day_of_week = "SATURDAY"
      time_of_day = "03:00"
      time_zone   = "UTC"
    }
  ]

}
