# CSV data creator module
module CsvDataCreator
  def create_csv(basis_date, project_evm, working_hours_per_day)
    Redmine::Export::CSV.generate do |csv|
      csv << ["STATUS DATE"]
      csv << [basis_date]
      csv << %w[PROJECT START END BAC PV EV AC SV CV SPI CPI]
      project_evm.each do |_id, evm|
        csv_value = []
        csv_value << evm.project_name
        csv_value << format_date(evm.pv.start_date)
        csv_value << format_date(evm.pv.due_date)
        csv_value << evm.bac(working_hours_per_day)
        csv_value << evm.today_pv(working_hours_per_day)
        csv_value << evm.today_ev(working_hours_per_day)
        csv_value << evm.today_ac(working_hours_per_day)
        csv_value << evm.today_sv(working_hours_per_day)
        csv_value << evm.today_cv(working_hours_per_day)
        csv_value << evm.today_spi(working_hours_per_day)
        csv_value << evm.today_cpi(working_hours_per_day)
        csv << csv_value
      end
    end
  end
end
