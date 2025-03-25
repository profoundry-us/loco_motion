# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::JsonExportService do
  let(:service) { described_class.new }
  
  # Sample records for testing
  let(:records) do
    [
      {
        objectID: 'record1',
        title: 'Test Record 1',
        description: 'Description for test record 1'
      },
      {
        objectID: 'record2',
        title: 'Test Record 2',
        description: 'Description for test record 2'
      }
    ]
  end
  
  let(:output_path) { File.join(Dir.pwd, 'tmp', 'test_export.json') }
  let(:output_dir) { File.dirname(output_path) }
  
  describe '#initialize' do
    it 'initializes the service' do
      expect(service).to be_a(described_class)
    end
  end
  
  describe '#export' do
    before do
      # Stub FileUtils and File operations
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:directory?).and_return(false)
      allow(File).to receive(:open).and_yield(StringIO.new)
      allow(StringIO.new).to receive(:write)
      allow(Rails.logger).to receive(:debug)
    end
    
    context 'with valid records and output path' do
      it 'creates the directory if it does not exist' do
        expect(FileUtils).to receive(:mkdir_p).with(output_dir)
        
        service.export(records, output_path)
      end
      
      it 'writes the records to the file as JSON' do
        expect(File).to receive(:open).with(output_path, 'w').and_yield(StringIO.new)
        expect_any_instance_of(StringIO).to receive(:write) do |_, data|
          # Verify JSON format
          json = JSON.parse(data)
          expect(json.length).to eq(2)
          expect(json[0]['objectID']).to eq('record1')
          expect(json[1]['objectID']).to eq('record2')
        end
        
        service.export(records, output_path)
      end
      
      it 'returns true on success' do
        result = service.export(records, output_path)
        
        expect(result).to be true
      end
      
      it 'logs a debug message on success' do
        expect(Rails.logger).to receive(:debug).with("Data exported to #{output_path}")
        
        service.export(records, output_path)
      end
    end
    
    context 'when directory already exists' do
      before do
        allow(File).to receive(:directory?).and_return(true)
      end
      
      it 'does not create the directory again' do
        expect(FileUtils).not_to receive(:mkdir_p)
        
        service.export(records, output_path)
      end
      
      it 'still writes the file and returns true' do
        expect(File).to receive(:open).with(output_path, 'w')
        
        result = service.export(records, output_path)
        expect(result).to be true
      end
    end
    
    context 'with nil records' do
      it 'returns false without attempting to write' do
        expect(File).not_to receive(:open)
        
        result = service.export(nil, output_path)
        expect(result).to be false
      end
    end
    
    context 'with nil output path' do
      it 'returns false without attempting to write' do
        expect(File).not_to receive(:open)
        
        result = service.export(records, nil)
        expect(result).to be false
      end
    end
    
    context 'with empty output path' do
      it 'returns false without attempting to write' do
        expect(File).not_to receive(:open)
        
        result = service.export(records, '')
        expect(result).to be false
      end
    end
    
    context 'when an error occurs during export' do
      before do
        allow(File).to receive(:open).and_raise('Test error')
      end
      
      it 'returns false' do
        result = service.export(records, output_path)
        
        expect(result).to be false
      end
      
      it 'logs error information' do
        # Stub Rails.logger to avoid actual output and allow for verification
        expect(Rails.logger).to receive(:debug).with(/Error exporting to JSON: Test error/).ordered
        # The backtrace will be output in a separate call
        expect(Rails.logger).to receive(:debug).ordered
        
        service.export(records, output_path)
      end
    end
  end
end
