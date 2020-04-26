# Issue data fetcher
# This module is a function to collect ISSUE records necessary to calculate EVM
# It also collects a selectable list that is optionally specified
#
module IssueDataFetcher2
  # Common condition of issue's select
  SQL_COM = <<-SQL_COM.freeze
  (issues.project_id = ?)
  AND
  (issues.start_date IS NOT NULL AND issues.due_date IS NOT NULL)
  OR
  (issues.start_date IS NOT NULL
   AND
   issues.due_date IS NULL
   AND
   issues.fixed_version_id IN (SELECT id FROM versions WHERE effective_date IS NOT NULL))
  SQL_COM

  # Common condition of issue's join for parent issue
  SQL_JOIN = <<-"SQL_JOIN".freeze
  JOIN #{Issue.table_name} ancestors
    ON ancestors.root_id = #{Issue.table_name}.root_id
    AND ancestors.lft <= #{Issue.table_name}.lft
    AND ancestors.rgt >= #{Issue.table_name}.rgt
  SQL_JOIN

  # Get issues of EVM for PV and EV.
  # Include descendants project. Rerequires inputted start date and due date.
  # for use calculate PV and EV.
  #
  # @param [numeric] project_id project object
  # @return [Issue] issue object
  def evm_issues(project_id)
    Issue.where(SQL_COM.to_s, project_id)
  end

  # Get spent time of project.
  # Include descendants project.require inputted start date and due date.
  #
  # @param [numeric] project_id project
  # @return [hash] Two column,spent_on,sum of hours
  def evm_costs(project_id)
    Issue.where(SQL_COM.to_s, project_id).
      joins(:time_entries).
      group(:spent_on).sum(:hours)
  end

  # latest setted done ratio journal
  #
  # @param [issue] issue issue record
  # @param [date] basis_date basis date
  # @return [journal] first of journals
  def issue_journal(issue, basis_date)
    Journal.where(journalized_id: issue.id, journal_details: { prop_key: "done_ratio" }).
      where("created_on <= ?", basis_date.end_of_day).
      includes(:details).
      order(created_on: :DESC).first
  end

  # children of parent isuue
  #
  # @param [issue] issue parent issue
  # @return [issue] cildren issue
  def issue_child(issue)
    Issue.where(root_id: issue.root_id).
      where("lft > ? AND rgt < ?", issue.lft, issue.rgt).
      order(closed_on: :DESC).first
  end
end
