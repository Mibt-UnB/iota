
package RNSP::PCS::Schema::ResultSet::Indicator;

use namespace::autoclean;

use Moose;
extends 'DBIx::Class::ResultSet';
with 'RNSP::PCS::Role::Verification';
with 'RNSP::PCS::Schema::Role::InflateAsHashRef';

use Data::Verifier;
use RNSP::IndicatorFormula;

sub _build_verifier_scope_name {'indicator'}

sub verifiers_specs {
    my $self = shift;
    return {
        create => Data::Verifier->new(
            profile => {
                name        => { required => 1, type => 'Str' },
                formula     => { required => 1, type => 'Str',
                    post_check => sub {
                        my $r = shift;
                        my $f = eval{new RNSP::IndicatorFormula(
                            formula => $r->get_value('formula'),
                            schema  => $self->result_source->schema)};
                        return $@ eq '';
                    },
                },
                goal        => { required => 0, type => 'Num' },
                axis        => { required => 1, type => 'Str' },
                user_id     => { required => 1, type => 'Int' },
                source       => { required => 0, type => 'Str' },
                explanation  => { required => 0, type => 'Str' },

                justification_of_missing_field => { required => 0, type => 'Str' },

                goal_source     => { required => 0, type => 'Str' },
                tags            => { required => 0, type => 'Str' },
                goal_operator   => { required => 0, type => 'Str' },
                chart_name      => { required => 0, type => 'Str' },

                goal_explanation  => { required => 0, type => 'Str' },
                sort_direction    => { required => 0, type => 'Str' },

            },
        ),

        update => Data::Verifier->new(
            profile => {
                id          => { required => 1, type => 'Int' },
                name        => { required => 0, type => 'Str' },
                formula     => { required => 0, type => 'Str',
                    post_check => sub {
                        my $r = shift;
                        my $f = eval{new RNSP::IndicatorFormula(
                            formula => $r->get_value('formula'),
                            schema  => $self->result_source->schema)};
                        return $@ eq '';
                    },
                },
                goal        => { required => 0, type => 'Num' },
                axis        => { required => 0, type => 'Str' },
                source       => { required => 0, type => 'Str' },
                explanation  => { required => 0, type => 'Str' },

                justification_of_missing_field => { required => 0, type => 'Str' },

                goal_source     => { required => 0, type => 'Str' },
                tags            => { required => 0, type => 'Str' },
                goal_operator   => { required => 0, type => 'Str' },

                goal_explanation  => { required => 0, type => 'Str' },
                sort_direction    => { required => 0, type => 'Str' },
                chart_name      => { required => 0, type => 'Str' },
            },
        ),



    };
}

sub action_specs {
    my $self = shift;
    return {
        create => sub {
            my %values = shift->valid_values;
            do { delete $values{$_} unless defined $values{$_}} for keys %values;
            return unless keys %values;

            my $var = $self->create( \%values );

            $var->discard_changes;
            return $var;
        },
        update => sub {
            my %values = shift->valid_values;

            do { delete $values{$_} unless defined $values{$_}} for keys %values;
            return unless keys %values;

            my $var = $self->find( delete $values{id} )->update( \%values );
            $var->discard_changes;
            return $var;
        },

    };
}

1;

