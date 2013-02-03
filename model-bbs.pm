package Model::bbs;

use Mojolicious::Lite;
use Mojo::ByteStream 'b';
use Encode;
use utf8;
use feature 'say';
use DateTimeEasy 'datestr';


sub new {
	my $self = {};
	my $app = app;
  $self->{data_file} = $app->home->rel_file('bbs-data.txt');
	bless $self, shift;
}

sub view_message {
	my $self = shift;

	my $data_file = $self->{data_file};
	my $mode = -f $data_file ? '<' : '+>';
	open my $data_fh, $mode, $data_file or die "Cannot open $data_file: $!";

	my $entry_infos = [];
	while (my $line = <$data_fh>){
		chomp $line;
#		say $line;
		$line = decode_utf8($line);
		my @record = split /\t/, $line;
		my $entry_info = ();
		$entry_info->{datetime} = $record[0];
		$entry_info->{title} = $record[1];
		$entry_info->{message} = $record[2];
		push @$entry_infos, $entry_info;
	}

	close $data_fh;
	@$entry_infos = reverse @$entry_infos;
	my $res = $entry_infos;
	return $res;
}

sub write_message {

	my $self = shift;
	my $input = shift;
	my $title =  $input->{title};
	my $message = $input->{message};
	my $data_file = $self->{data_file};

	my $res = {};
	return $res = { err => 1,  template => 'error', message => 'Please input title'} unless $title;
	return $res = { err => 1,  template => 'error', message => 'Please input message' } unless $message;
	return $res = { err => 1,  template => 'error', message => 'Title is too long' } if length $title > 30;
	return $res = { err => 1,  template => 'error', message => 'Message is too long '} if length $message > 100;


#	say $title;
#	say $message;


	my $now = localtime;
	my $datetime = datestr($now, 'standard');

	$message =~ s/\x0D\x0A|\x0D|\x0A//g;

	my $record = join("\t", $datetime, $title, $message) . "\n";

	open my $data_fh, ">>", $data_file or die "Cannot open $data_file: $!";

	$record = b($record)->encode('UTF-8')->to_string;
	
	print $data_fh $record;
	close $data_fh;
	
	return	$res = {err => 0, message => 'message written' };
}
		
1;
