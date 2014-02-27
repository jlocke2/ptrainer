json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :name, :description, :client_id
  json.start appointment.start_at
  json.end appointment.end_at
  json.title appointment.name
end