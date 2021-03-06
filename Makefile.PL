#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Iota';
all_from 'lib/Iota.pm';

requires 'Catalyst::Runtime' => '5.90010';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';


requires 'XML::LibXML';
requires 'HTML::HTML5::Writer';
requires 'RDF::Helper';
requires 'RDF::Endpoint';

requires 'Geo::Google::PolylineEncoder';
requires 'I18N::AcceptLanguage';
requires 'HTML::Scrubber';

requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Component::InstancePerContext';
requires 'Catalyst::Plugin::Params::Nested';
requires 'Catalyst::Controller::REST';
requires 'Catalyst::TraitFor::Controller::DBIC::DoesPaging';
requires 'DBIx::Class::PassphraseColumn';
requires 'DBIx::Class::TimeStamp';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Graphics::Color::RGB';
requires 'Color::Scheme';
requires 'MooseX::Types::Email';
requires 'Data::Diver';
requires 'Data::Printer';
requires 'Data::Manager';
requires 'FindBin';
requires 'JSON';
requires 'JSON::XS';
requires 'List::MoreUtils';
requires 'String::Random';
requires 'Crypt::PasswdMD5';
requires 'DateTime::Duration';
requires 'Catalyst::Plugin::Unicode::Encoding';
requires 'DateTime::Format::Duration';
requires 'DateTimeX::Easy';
requires 'DateTime::Format::Pg';
requires 'Catalyst::View::TT';

requires 'Geo::Coder::Google';
requires 'Text::Iconv';
requires 'Email::Sender';
requires 'Email::Sender::Simple';
requires 'Spreadsheet::WriteExcel';
requires 'Email::Sender::Transport::SMTP::TLS';
requires 'Email::MIME';
requires 'Spreadsheet::XLSX';
requires 'Spreadsheet::ParseExcel::Stream';
requires 'DateTime::Format::Excel';
requires 'Math::Expression::Evaluator';
requires 'Template';
requires 'CSS::Minifier::XS';
requires 'JavaScript::Minifier::XS';

requires 'Catalyst::Plugin::Assets';
requires 'Statistics::Basic';

requires 'Catalyst::Plugin::StatusMessage';

requires 'Template::AutoFilter';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Session::DynamicExpiry';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::PerUser';
requires 'Catalyst::Plugin::Session::Store::File';





requires 'Text::CSV_XS';
requires 'Digest::MD5';
requires 'Text2URI' => '0.4';
requires 'MooseX::Traits';
requires 'DBD::Pg';
requires 'Statistics::Descriptive';
requires 'XML::Simple';

requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
test_requires 'Test::Deep';
tests_recursive('t');
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;



