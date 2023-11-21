# spec/factories/patient_records.rb

FactoryBot.define do
    factory :patient_record do
      diagnosed_with { 'Test Diagnosis' }
      diagnosed_by { 1 } # Assuming you have a doctor in your system with id 1
      prescription { 'Test Prescription' }
      vaccine_id { 1 } # Assuming you have a vaccine in your system with id 1
      test_id { 1 } # Assuming you have a test in your system with id 1
      service_id { 1 } # Assuming you have a service in your system with id 1
      
    end
  end
  