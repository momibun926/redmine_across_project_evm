require "calculate_evm_logic2"
require "data_fetcher"

# EVM creator module
module EvmCreator
  include CalculateEvmLogic2
  include DataFetcher

  # Culculation of EMM
  def evm_create(basis_date)
    projects_evm = {}
    projects = target_projects Project::STATUS_ACTIVE
    projects.each do |proj|
      issues = evm_issues proj.id
      issues_costs = evm_costs proj.id
      projects_evm[proj.id] = CalculateEvmLogic2::CalculateEvm2.new basis_date, issues, issues_costs
      projects_evm[proj.id].project_name = proj.name
    end
    projects_evm
  end

  def target_projects(status)
    Project.where(status: status).
      where("projects.id IN (select project_id FROM members WHERE user_id = ?)", User.current.id)
  end
end
