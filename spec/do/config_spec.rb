require 'do'

describe 'Do.config' do
  it 'returns the default config' do
    expect(Do.config).to eq(OpenStruct.new({
      wdid: '~/wdid.md',
      config_file: '.dorc',
      current_section: 'Currently',
      date_format: '%Y-%m-%d %H:%M'
    }))
  end
end
