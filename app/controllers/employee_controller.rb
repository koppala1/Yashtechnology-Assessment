class EmployeeController < ApplicationController

before_action :set_employee, only: [:update]

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      notify_third_party_services(@employee)
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      notify_third_party_services(@employee)
      render json: @employee, status: :ok
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Employee not found' }, status: :not_found
  end

  def employee_params
    params.require(:employee).permit(:employee_name, :employee_id)
  end

  def notify_third_party_services(@employee)
    third_party_apis.each do |service, url|
      HTTParty.post(url, body: @employee.to_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{generate_auth_token}" })
    end
  end

  def third_party_apis
    YAML.load_file(Rails.root.join('config', 'third_party_apis.yml'))[Rails.env].symbolize_keys
  end

  def generate_auth_token
    JWT.encode({ exp: 1.hour.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end


end #class end
