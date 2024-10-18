# CustomFormGenerator

## Overview

CustomFormGenerator is a Ruby gem designed to dynamically generate HTML forms and tables based on JSON configurations. It leverages the Slim templating engine to render forms, filter, sort options, and tabular views.

## Installation

Add this line to your application's Gemfile:

    gem 'custom_form_generator', path: '/path/to/custom_form_generator'
And then execute:

    bundle install

## Usage

### Preparation

To use CustomFormGenerator, you need to provide few JSON files that defines the structure of your form or table. Currently supporting use cases of 3 such files:
- form.json
- data.json
- config.json

#### form.json
```
[
  { "type": "textfield", "label": "Name", "key": "name" },
  { "type": "dropdown", "label": "Gender", "key": "gender" }
]

```

#### data.json
```
{
  "name": "John Doe",
  "gender": ["Male", "Female", "Other"]
}
```

#### config.json
```
{
  "sort": [{"key": "name", "label": "Name"}, {"key": "date", "label": "Date"}],
  "filter": [{"key": "active", "label": "Active"}]
}
```

### Generating form
Use the generate_form method to generate HTML form based on the provided JSON configuration files.
```
require 'custom_form_generator'

form_json = 'path/to/form.json'
data_json = 'path/to/data.json'
config_json = 'path/to/config.json'

generator = CustomFormGenerator::Generator.new(form_json, data_json, config_json)
html_form = generator.generate_form
puts html_form
```
### Generating filer and sort
Use generate_filter_sort method to generate HTML form based on the provided JSON configuration files.
```
filter_html = generator.generate_filter_and_sort
puts filter_html
```

### Generating table
Use generate_tabular_view(data) method to generate HTML table based on the provided JSON configuration files.
```
data = [{ "name": "John Doe", "gender": "Male" }]
table_html = generator.generate_tabular_view(data)
puts table_html
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Manmohan-menon/SlimForms_gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Manmohan-menon/SlimForms_gem/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomFormGenerator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Manmohan-menon/SlimForms_gem/CODE_OF_CONDUCT.md).
