class CrossProjectEvmController < ApplicationController
  include IssueDataFetcher2
  include CalculateEvmLogic2

  def index
    @projects_evm = {}
    selected_projects = Project.where(status: 1).
                          where("members.user_id = ?", User.current.id).
                          joins(:members).
                          pluck(:id, :name)
    selected_projects.each do |proj_id, proj_name|
      issues = evm_issues proj_id
      issues_costs = evm_costs proj_id
      @projects_evm[proj_id] = CalculateEvm2.new Time.current.to_date, issues, issues_costs
      @projects_evm[proj_id].description = proj_name
    end
  end
end
