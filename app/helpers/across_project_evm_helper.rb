# parent issue helper
module AcrossProjectEvmHelper
  # link of target project
  def project_link(proj_id, proj_name)
    link_to(proj_name, project_path(proj_id))
  end

  # unit
  def explanation_of_unit(working_hours_per_day)
    unit = working_hours_per_day == 1.0 ? l(:unit_evm_hours) : l(:unit_evm_days)
    content_tag(:p, unit)
  end

  # selectable project status
  def selectable_project_status
    [[l(:project_status_active), Project::STATUS_ACTIVE],
     [l(:project_status_closed), Project::STATUS_CLOSED],
     [l(:project_status_archived), Project::STATUS_ARCHIVED]]
  end

  # project status name
  def project_status_name(status)
    h = Hash[*selectable_project_status.flatten]
    h.invert[status]
  end

  # project duration with font color
  def project_duration(basis_date, evm)
    value = "#{format_date(evm.pv.start_date)} - #{format_date(evm.pv.due_date)}"
    content_tag(:td, value, class: project_duration_color(basis_date, evm))
  end

  # duration color
  def project_duration_color(basis_date, evm)
    if evm.project_status != Project::STATUS_ACTIVE
      ""
    elsif evm.pv.due_date < basis_date
      "duration-indicator-red"
    else
      ""
    end
  end

  # permitted params at download csv
  def permitted_params(params)
    params.permit(:basis_date, :working_hours_per_day, selected_status: [])
  end
end
