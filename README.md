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

To use CustomFormGenerator, you need to provide few JSON and YAML files that defines the structure of your form or table. Currently supporting use cases of 4 such files:
- form.yml
- data.json
- config.json
- table.yml

#### form.yml
```
- type: textfield
  label: Name
  key: properties.name
  id: name_input
  class: form-control
- type: dropdown
  label: Language
  key: language
  id: language_select
  class: form-select
  disabled: true
```

#### data.json
```
[
  {
    "_id": { "$oid": "64df" },
    "language": "jp",
    "name": "Kishimoto S",
    "properties": {
      "name": "Kishimoto S",
      "categories": ["/Yusuke/Urameshi"],
      "sku": "B3743-B001"
    }
  }
]

```

#### config.json
```
{
  "sort": [
    { "key": "name", "label": "Name" },
    { "key": "created_at", "label": "Created At" }
  ],
  "filter": [
    { "key": "language", "label": "Language" },
    { "key": "published_at", "label": "Published At", "type": "radio", "options": ["all", "yes", "no"], "default": "all" }
  ],
  "order_by": [
    { "key": "asc", "label": "Ascending" },
    { "key": "desc", "label": "Descending" }
  ]
}

```

#### table.yml
```
- key: images_url
  label: Image
  id: image_column
  class: table-column
- key: properties.name
  label: Name
  id: name_column
  class: table-column
```

### Usage Example

```
require 'custom_form_generator'

generator = CustomFormGenerator::Generator.new(
  'path/to/form.yml',
  'path/to/data.json',
  'path/to/config.json',
  'path/to/table.yml'
)

# Generate form
html_form = generator.generate_form

# Generate filter and sort
filter_html = generator.generate_filter_and_sort

# Generate table view
table_html = generator.generate_tabular_view(data)
```

## Development

After checking out the repo, run bin/setup to install dependencies. Then, run rake spec to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Manmohan-menon/SlimForms_gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Manmohan-menon/SlimForms_gem/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomFormGenerator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Manmohan-menon/SlimForms_gem/CODE_OF_CONDUCT.md).
