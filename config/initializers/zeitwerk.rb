Rails.application.config.to_prepare do
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/shared"), namespace: Shared)
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/employee"), namespace: Employee)
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/client"), namespace: Client)
end