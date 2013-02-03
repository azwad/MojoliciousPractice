package Model::plane_text;
use utf8;
use feature 'say';

sub new {
	bless { }, shift;
}

sub method {
	my ( $self, $input) = @_;
	return unless $input;
	my $result_text = $input;
	return $result_text;
}

sub DESTROY {
	my $self = shift;
	say 'Object Destoroied';
}
1;


