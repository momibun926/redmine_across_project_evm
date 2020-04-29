require "calculate_evm_logic2"
require "data_fetcher"

# EVM creator module
module EvmCreator
  include CalculateEvmLogic2
  include DataFetcher

  # project evm
  def create_project_evm(basis_date, selected_status)
    projects = target_projects selected_status
    calculate_evm basis_date, projects
  end

  def target_projects(status)
    Project.where(status: status).
      where("projects.id IN (select project_id FROM members WHERE user_id = ?)", User.current.id)
  end

  def calculate_evm(basis_date, projects)
    evm = {}
    projects.each do |proj|
      issues = evm_issues proj.id
      issues_costs = evm_costs proj.id
      evm[proj.id] = CalculateEvmLogic2::CalculateEvm2.new basis_date, issues, issues_costs
      evm[proj.id].project_name = proj.name
      evm[proj.id].project_status = proj.status
    end
    evm
  end
end
