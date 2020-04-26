# module
module DataFetcher
  # Common condition of issue's select
  SQL_COM = <<-SQL_COM.freeze
  (issues.start_date IS NOT NULL AND issues.due_date IS NOT NULL)
  OR
  (issues.start_date IS NOT NULL
   AND
   issues.due_date IS NULL
   AND
   issues.fixed_version_id IN (SELECT id FROM versions WHERE effective_date IS NOT NULL))
  SQL_COM

  def evm_issues(project_id)
    Issue.where(project_id: project_id).
      where(SQL_COM.to_s)
  end

  def evm_costs(project_id)
    Issue.where(project_id: project_id).
      where(SQL_COM.to_s).
      joins(:time_entries).
      group(:spent_on).sum(:hours)
  end

  def issue_journal(issue, basis_date)
    Journal.where(journalized_id: issue.id, journal_details: { prop_key: "done_ratio" }).
      where("created_on <= ?", basis_date.end_of_day).
      includes(:details).
      order(created_on: :DESC).first
  end

  def issue_child(issue)
    Issue.where(root_id: issue.root_id).
      where("lft > ? AND rgt < ?", issue.lft, issue.rgt).
      order(closed_on: :DESC).first
  end

  def project_ids_in_member(member_id)
    Project.where(status: 1).
      where("members.user_id = ?", member_id).
      joins(:members).
      pluck(:id)
  end
end
