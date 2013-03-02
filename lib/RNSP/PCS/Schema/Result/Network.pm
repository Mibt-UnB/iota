use utf8;
package RNSP::PCS::Schema::Result::Network;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

RNSP::PCS::Schema::Result::Network

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<network>

=cut

__PACKAGE__->table("network");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'network_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 name_url

  data_type: 'text'
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 created_by

  data_type: 'integer'
  is_nullable: 0

=head2 users_can_edit_value

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 users_can_edit_groups

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "network_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "name_url",
  { data_type => "text", is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "created_by",
  { data_type => "integer", is_nullable => 0 },
  "users_can_edit_value",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "users_can_edit_groups",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<network_name_url_key>

=over 4

=item * L</name_url>

=back

=cut

__PACKAGE__->add_unique_constraint("network_name_url_key", ["name_url"]);

=head1 RELATIONS

=head2 indicator_network_configs

Type: has_many

Related object: L<RNSP::PCS::Schema::Result::IndicatorNetworkConfig>

=cut

__PACKAGE__->has_many(
  "indicator_network_configs",
  "RNSP::PCS::Schema::Result::IndicatorNetworkConfig",
  { "foreign.network_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: has_many

Related object: L<RNSP::PCS::Schema::Result::User>

=cut

__PACKAGE__->has_many(
  "users",
  "RNSP::PCS::Schema::Result::User",
  { "foreign.network_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-02 04:07:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Cu3HuQT0HT3YBShjZ7zRpg



# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;