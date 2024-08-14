a Rails 7 application with a German-only frontend. 

The application has been initialized with the following configuration:

Database: PostgreSQL
Account Management: Devise
Asset Management: Propshaft
JS Bundler: esbuild (js-bundling-rails)
JS Framework: Stimulus
CSS Framework: Tailwind CSS
Streamlining: Turbo
 
User Account Database Structure:

Separate Tables with Shared Association approach

Requirements:
a registerd User is either going to be associated with a
- Employee
- Client
  - A Client is associated with 0 or more Patients
