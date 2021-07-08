package Math::Cryptarithm;

use strict;
use warnings;
use Algorithm::Permute;
use 5.0.0;

sub new {
    my ($class) = @_;
    bless {
        _equations => $_[1]
    }, $class;
}

sub _check_syntax_of_an_equation {
    my $equation = $_[0];
    # to be written
    return 1;
}

sub _seperate_lhs_rhs {
    my $eq_text = $_[0];
    my $i = index($eq_text, "=");
    return [ substr($eq_text, 0, $i ), substr($eq_text, $i+1) ];
}

sub _replacement {
    my $original_text = $_[0];
    my $text = $_[0];
    my @arr_ab = @{$_[1]};
    my @arr_digits = @{$_[2]};
    for (0..$#arr_digits) {
        $text =~ s/$arr_ab[$_]/$arr_digits[$_]/g;
    }

    #BEGIN: cut leading zeros
    substr($text,0,1) = " " 
        if substr($text,0,1) eq '0' && substr($text,1,1) =~ m/[0-9]/;
    for my $i (1..(length($text) - 2) ) {
        if (    substr($text,$i,1) eq '0' 
             && substr($text,$i-1,1) !~ m/[1-9]/
             && substr($text,$i+1,1) =~ m/\d/ ) 
        { 
            substr($text,$i,1) = " ";
        }
    }
    #END cut leading zeros
    return $text;
}

sub _list_alphabets {
    my @eq = @{$_[0]};
    my %abcdz;
    for my $symbol ('A'..'Z') {
        for my $e (@eq) {
            $abcdz{$symbol} = 1 if $e =~ m/$symbol/;
        }
    }
    return [sort keys %abcdz];
}

sub equations {
    $_[0]->{_equations};
}

sub solve {
    my ($self) = @_;
    my @eqs = @{$self->equations};
    my @answers = ();

    _check_syntax_of_an_equation($_) foreach @eqs;

    my @eqs_lhs, my @eqs_rhs;
    foreach (@eqs) {
        my $temp_l, my $temp_r;
        ($temp_l, $temp_r) = _seperate_lhs_rhs($_)->@*;
        push @eqs_lhs, $temp_l;
        push @eqs_rhs, $temp_r;
    }

    my @arr_alphabets = _list_alphabets(\@eqs)->@*;
    my $num_of_alphabets = scalar @arr_alphabets; 

    my $iter = Algorithm::Permute->new([0..9], $num_of_alphabets);
    COMBIN_TEST: while (my @res = $iter->next) {
        my $ok = undef;
        for my $i (0..$#eqs) {
            $ok = undef;
            my $str_lhs = 
                _replacement( $eqs_lhs[$i] , \@arr_alphabets, \@res );
            my $str_rhs = 
                _replacement( $eqs_rhs[$i] , \@arr_alphabets, \@res );
            die "LHS is not numeric:\n $eqs_lhs[$i]\n\"$str_lhs\"\n" 
                if (eval $str_lhs) !~ m/^[0-9]+$/;
            die "RHS is not numeric:\n $eqs_rhs[$i]\n\"$str_rhs\"\n" 
                if (eval $str_rhs) !~ m/^[0-9]+$/;
            next COMBIN_TEST unless (eval $str_lhs) == (eval $str_rhs) ;
            $ok = 1;
        }
        if ($ok) {
            my %temp_hash;
            for my $i (0..$num_of_alphabets-1) {
                $temp_hash{$arr_alphabets[$i]} = $res[$i];
            }
            push @answers, \%temp_hash;
        }
    }
    return \@answers;
}

sub solve_ans_in_equations {
    my ($self) = @_;
    my @eqs = @{$self->equations};
    my @answers_of_hashes = $self->solve()->@*;
    my @answers_in_eq;
    for my $my_hash (@answers_of_hashes) {
        my @a_set_of_answer_in_eq;
        for my $crypt_eq (@eqs) {
            my $numeric_eq = $crypt_eq;
            foreach my $k (keys %{$my_hash}) {
                my $digit = $$my_hash{$k};
                $numeric_eq =~ s/$k/$digit/g;
            } 
            push @a_set_of_answer_in_eq, $numeric_eq;
        }
        push @answers_in_eq, \@a_set_of_answer_in_eq;
    }
    return \@answers_in_eq;
}

1;
