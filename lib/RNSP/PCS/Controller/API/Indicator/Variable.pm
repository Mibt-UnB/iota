
package RNSP::PCS::Controller::API::Indicator::Variable;

use Moose;
use JSON qw(encode_json);
use RNSP::IndicatorFormula;

BEGIN { extends 'Catalyst::Controller::REST' }

__PACKAGE__->config( default => 'application/json' );

sub base : Chained('/api/indicator/object') : PathPart('variable') : CaptureArgs(0) {
  my ( $self, $c ) = @_;

  $c->stash->{indicator}  = $c->stash->{object}->next;
}


sub values: Chained('base') : PathPart('value') : Args(0 ): ActionClass('REST') {
  my ( $self, $c ) = @_;
}


=pod

GET /api/indicator/<ID>/variable/value

retorna os valores das variaveis em forma de tabela

{
    "rows": [
        {
            "valores": [
                {
                    "value": "21",
                    "value_of_date": "1192-01-21T00:00:00"
                },
                {
                    "value": "1",
                    "value_of_date": "1192-01-21T00:00:00"
                }
            ],
            "valid_from": "1192-01-22T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "22",
                    "value_of_date": "1192-02-12T00:00:00"
                },
                {
                    "value": "2",
                    "value_of_date": "1192-02-12T00:00:00"
                }
            ],
            "valid_from": "1192-02-12T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "25",
                    "value_of_date": "1192-03-25T00:00:00"
                },
                {
                    "value": "5",
                    "value_of_date": "1192-03-25T00:00:00"
                }
            ],
            "valid_from": "1192-03-25T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "25",
                    "value_of_date": "2011-01-21T00:00:00"
                },
                {
                    "value": "5",
                    "value_of_date": "2011-01-21T00:00:00"
                }
            ],
            "valid_from": "2011-01-15T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "27",
                    "value_of_date": "2011-02-12T00:00:00"
                },
                {
                    "value": "7",
                    "value_of_date": "2011-02-12T00:00:00"
                }
            ],
            "valid_from": "2011-02-05T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "27",
                    "value_of_date": "2011-03-25T00:00:00"
                },
                {
                    "value": "7",
                    "value_of_date": "2011-03-25T00:00:00"
                }
            ],
            "valid_from": "2011-03-19T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "29",
                    "value_of_date": "2011-04-16T00:00:00"
                },
                {
                    "value": "9",
                    "value_of_date": "2011-04-16T00:00:00"
                }
            ],
            "valid_from": "2011-04-09T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "25",
                    "value_of_date": "2012-02-22T00:00:00"
                },
                {
                    "value": "5",
                    "value_of_date": "2012-02-22T00:00:00"
                }
            ],
            "valid_from": "2012-02-19T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "26",
                    "value_of_date": "2012-03-08T00:00:00"
                },
                {
                    "value": "6",
                    "value_of_date": "2012-03-08T00:00:00"
                }
            ],
            "valid_from": "2012-03-04T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "28",
                    "value_of_date": "2012-04-12T00:00:00"
                },
                {
                    "value": "8",
                    "value_of_date": "2012-04-12T00:00:00"
                }
            ],
            "valid_from": "2012-04-08T00:00:00"
        },
        {
            "valores": [
                {
                    "value": "23",
                    "value_of_date": "2012-01-01T00:00:00"
                },
                {
                    "value": "3",
                    "value_of_date": "2012-01-01T00:00:00"
                }
            ],
            "valid_from": "2012-12-23T00:00:00"
        }
    ],
    "header": {
        "nostradamus": 1,
        "Temperatura semanal": 0
    }
}


=cut

sub values_GET {
    my ( $self, $c ) = @_;
    my $ret;
    eval {
        my $indicator = $c->stash->{indicator};

        my $indicator_formula = new RNSP::IndicatorFormula(
            formula => $indicator->formula,
            schema => $c->model('DB')->schema
        );

        my $rs = $c->model('DB')->resultset('Variable')->search_rs({
            -or => [
                'values.user_id' => $c->user->id,
                'values.user_id' => undef,
            ],
            'me.id' => [$indicator_formula->variables]
        }, { prefetch => ['values'] } );


        my $hash = {};
        my $tmp  = {};
        my $x = 0;
        while (my $row = $rs->next){
            $hash->{header}{$row->name} = $x;

            foreach my $value ($row->values){
                push @{$tmp->{$value->valid_from}}, {
                    col           => $x,
                    value_of_date => $value->value_of_date->datetime,
                    value         => $value->value
                }
            }
            $x++;
        }

        foreach my $begin (sort {$a cmp $b} keys %$tmp){

            my @order = sort {$a->{col} <=> $b->{col}} @{$tmp->{$begin}};

            my $item = {
                valid_from => $begin,
                valores    => [map { +{
                    value_of_date => $_->{value_of_date},
                    value         => $_->{value}

                } } @order ]
            };

            push @{$hash->{rows}}, $item;

        }
        $ret = $hash;
    };
    if ($@){
        $self->status_bad_request(
            $c,
            message => $@,
        );
    }else{
        $self->status_ok(
            $c,
            entity => $ret
        );
    }
}


sub period: Chained('base') : PathPart('period') : CaptureArgs( 1 ) {
    my ( $self, $c, $date ) = @_;
    $self->status_bad_request( $c, message => encode_json( { 'invalid.date' => 1 } ) ), $c->detach
        unless $date =~ /^\d{4}-\d{2}-\d{2}$/;

    $c->stash->{valid_from} = $date;
}

sub by_period :Chained('period') : PathPart('') : Args( 0 ) : ActionClass('REST') {}


=pod



GET /api/indicator/<ID>/variable/period/2010-01-01

retorna as variaveis de um indicador para um determinado periodo

{
    "valid_from": "2012-01-01",
    "rows": [
        {
            "source": null,
            "is_basic": 0,
            "value": "23",
            "name": "Temperatura semanal",
            "explanation": "a foo with bar",
            "value_id": 304,
            "cognomen": "temp_semana",
            "value_of_date": "2012-01-05T00:00:00",
            "type": "int",
            "id": 216
        },
        {
            "source": null,
            "is_basic": 0,
            "value": "3",
            "name": "nostradamus",
            "explanation": "nostradamus end of world",
            "value_id": 305,
            "cognomen": "nostradamus",
            "value_of_date": "2012-01-04T00:00:00",
            "type": "int",
            "id": "217"
        },
        {
            "source": null,
            "is_basic": 0,
            "value": null,
            "name": "XXXX",
            "explanation": "a foo with bar",
            "value_id": null,
            "cognomen": "XXXAA",
            "value_of_date": null,
            "id": "215",
            "type": "int"
        }
    ]
}

=cut

sub by_period_GET {
    my ( $self, $c ) = @_;
    my $ret;
    eval {
        my $indicator = $c->stash->{indicator};

        my $indicator_formula = new RNSP::IndicatorFormula(
            formula => $indicator->formula,
            schema => $c->model('DB')->schema
        );

        my $rs = $c->model('DB')->resultset('Variable')->search_rs({
            -or => [
                'values.user_id' => $c->user->id,
                'values.user_id' => undef,
            ],
            'me.id' => [$indicator_formula->variables],

        }, { prefetch => ['values'] } );
        $rs = $rs->search_rs({
            -or => [
                'values.valid_from' => $c->stash->{valid_from},
                'values.valid_from' => undef
            ]});

        my @rows;


        while (my $row = $rs->next){
            my $rowx = {
                (map { $_ => $row->$_ } qw /id name explanation cognomen type source is_basic/),

                value         => undef,
                value_of_date => undef,
                value_id      => undef,
            };

            foreach my $value ($row->values){

                $rowx = {
                    %{$rowx},
                    value         => $value->value,
                    value_of_date => $value->value_of_date->datetime,
                    value_id      => $value->id,
                };

                last; # so tem um mesmo

            }
            push @rows, $rowx;
        }


        $ret = {rows => \@rows, valid_from => $c->stash->{valid_from}};
    };

    if ($@){
        $self->status_bad_request(
            $c,
            message => $@,
        );
    }else{
        $self->status_ok(
            $c,
            entity => $ret
        );
    }
}

1;

