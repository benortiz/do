require 'do'

describe 'Do.config' do
  it 'returns the default config' do
    expect(Do.config).to eq(OpenStruct.new({
      storage: {
        local: {
          wdid: '~/wdid.md'
        }
      },
      default_project: 'Currently',
      date_format: '%Y-%m-%d %H:%M'
    }))
  end
end
