# Installation Guide for StimulusRailsDatatables

This guide will help you install and configure the StimulusRailsDatatables gem in your Rails application.

## Prerequisites

- Rails >= 7.0
- Ruby >= 3.0
- @hotwired/stimulus
- importmap-rails (or another JavaScript bundler)

## Step 1: Add the Gem

Add to your `Gemfile`:

```ruby
gem 'stimulus_rails_datatables'
```

Or for local development:

```ruby
gem 'stimulus_rails_datatables', path: '../stimulus_rails_datatables'
```

Then run:

```bash
bundle install
```

## Step 2: JavaScript Setup

### Option A: Using Importmap (Recommended)

The gem automatically registers its JavaScript modules with importmap. You just need to import and register the controllers:

In `app/javascript/controllers/index.js`:

```javascript
import DatatableController from 'stimulus_rails_datatables/datatables_controller'
import FilterController from 'stimulus_rails_datatables/filter_controller'
import { AppDataTable } from 'stimulus_rails_datatables/app_datatable'

application.register('datatable', DatatableController)
application.register('filter', FilterController)
window.AppDataTable = AppDataTable
```

### Option B: Using Webpack/esbuild

If you're using a different bundler, you may need to configure it to include the gem's JavaScript files.

## Step 3: Ensure DataTables.net is Available

The gem requires DataTables.net JavaScript libraries. If using importmap, add these to your `config/importmap.rb`:

```ruby
pin 'datatables.net', to: 'dataTables.min.js'
pin 'datatables.net-bs5', to: 'dataTables.bootstrap5.min.js'
pin 'datatables.net-responsive', to: 'dataTables.responsive.min.js'
pin 'datatables.net-responsive-bs5', to: 'responsive.bootstrap5.min.js'
```

And copy the vendor files to `vendor/javascript/` from:
- https://cdn.datatables.net/

## Step 4: Update Your Datatable Classes

Change your existing datatable classes to inherit from `StimulusRailsDatatables::BaseDatatable`:

**Before:**
```ruby
class UserDatatable < AjaxDatatablesRails::ActiveRecord
  # ...
end
```

**After:**
```ruby
class UserDatatable < StimulusRailsDatatables::BaseDatatable
  # ...
end
```

## Step 5: Update View Helpers (If Needed)

If you were using custom `Lib::DatatableHelper` or `Lib::FilterHelper`, remove those registrations from `ApplicationController`:

**Before:**
```ruby
class ApplicationController < ActionController::Base
  helper Lib::DatatableHelper
  helper Lib::FilterHelper
end
```

**After:**
```ruby
class ApplicationController < ActionController::Base
  # Helpers are automatically included by the gem
end
```

## Step 6: Test Your Implementation

1. Start your Rails server
2. Navigate to a page with datatables
3. Verify that:
   - Tables load correctly
   - Filtering works
   - Pagination functions
   - State is persisted in localStorage

## Troubleshooting

### ImportMap Errors

If you see errors about missing modules, ensure:
1. The gem is properly installed (`bundle list stimulus_rails_datatables`)
2. Your `config/importmap.rb` includes the DataTables pins
3. Restart your Rails server after installation

### Stimulus Controller Not Registered

If datatables don't initialize:
1. Check browser console for JavaScript errors
2. Verify controllers are registered in `app/javascript/controllers/index.js`
3. Ensure `@hotwired/stimulus` is installed and working

### CSS Styling Issues

The gem expects Bootstrap 5. If you're using a different CSS framework:
1. Adjust the DataTables theme in your datatable initialization
2. Override the default classes in your custom CSS

## Migration from Local Implementation

If you're migrating from a local implementation:

1. **Remove old files:**
   ```bash
   rm app/helpers/lib/datatable_helper.rb
   rm app/helpers/lib/filter_helper.rb
   rm app/javascript/libs/datatables.js
   rm app/javascript/libs/app_datatable.js
   rm app/javascript/libs/filter_helper.js
   ```

2. **Update imports in JavaScript files:**
   - Change `'libs/app_datatable'` → `'stimulus_rails_datatables/app_datatable'`
   - Change `'libs/datatables'` → `'stimulus_rails_datatables/datatables_controller'`
   - Change `'libs/filter_helper'` → `'stimulus_rails_datatables/filter_controller'`

3. **Update Ruby code:**
   - Change `BaseDatatable < AjaxDatatablesRails::ActiveRecord` → `BaseDatatable < StimulusRailsDatatables::BaseDatatable`
   - Remove helper registrations from controllers

## Next Steps

- Read the [README.md](README.md) for usage examples
- Check the [CHANGELOG.md](CHANGELOG.md) for version history
- Report issues on GitHub

## Support

For questions or issues, please open an issue on GitHub:
https://github.com/denmarkmeralpis/stimulus_rails_datatables/issues
