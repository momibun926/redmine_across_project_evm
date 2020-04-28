require "calculate_evm_logic2"
require "data_fetcher"

# module
module EvmCreator
  include CalculateEvmLogic2
  include DataFetcher

  def evm_create(basis_date, user_id)
    projects_evm = {}
    target_project_ids = project_ids_in_member user_id
    target_project_ids.each do |proj_id|
      issues = evm_issues proj_id
      issues_costs = evm_costs proj_id
      projects_evm[proj_id] = CalculateEvmLogic2::CalculateEvm2.new basis_date, issues, issues_costs
    end
    projects_evm
  end

  def project_ids_in_member(member_id)
    ids = []
    active_projects = Project.where("#{Project.table_name}.status = ?", 1)
    active_projects.each do |proj|
      ids << active_projects.first.id if User.current.member_of?(proj)
    end
    ids
  end
end
