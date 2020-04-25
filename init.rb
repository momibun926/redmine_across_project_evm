require "redmine"

# module define
Redmine::Plugin.register :redmine_cross_project_evm do
  name "Redmine Cross Project EVM Plugin"
  author "Hajime Nakagama"
  description "Earned value management calculation for cross project plugin."
  version "0.0.1"
  requires_redmine "4.0"
  url "https://github.com/momibun926/redmine_cross_project_evm"
  author_url "https://github.com/momibun926"

  permission :view_cross_project_evm, cross_project_evm: :index, require: :member

  # menu
  menu :top_menu,
       :Projectevm, { controller: :cross_project_evm, action: :index },
       caption: "test menu name"
end
