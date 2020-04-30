require "redmine"

# module define
Redmine::Plugin.register :redmine_across_project_evm do
  name "Redmine Tarck across Project with EVM"
  author "Hajime Nakagama"
  description "Earned value management calculation for across project plugin."
  version "0.0.3"
  requires_redmine "3.4"
  url "https://github.com/momibun926/redmine_across_project_evm"
  author_url "https://github.com/momibun926"

  # menu
  menu :application_menu,
       :Projectevm, { controller: :across_project_evm, action: :index },
       caption: :across_project_evm
end
