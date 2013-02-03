package Model::image_bbs;
use utf8;
use feature 'say';
use File::Basename 'basename';
use File::Path 'mkpath';
use Mojo::Upload;
use Mojolicious::Lite;
use lib qw(/home/toshi/perl/lib);
use DateTimeEasy qw(datestr);


sub new {
	my $self = {};
	my $app = app;
	my $static_path = @{$app->static->paths}[0];
#	say $static_path;
	my $image_base  = 'image-bbs/image';
	my $image_dir = "$static_path/$image_base";
#	say $image_dir;
	unless ( -d $image_dir ){
		say 'make directory';
		mkpath $image_dir or die "Cannot create dirctory $image_dir: $!";
	}
	bless $self, shift;
	$self->{path} = {
		'image_base' => $image_base,
		'image_dir'  => $image_dir,
	};
	return $self;
}

sub view_images {
	my $self = shift;
	my $res = {};
	my $image_dir = $self->{path}->{image_dir};
	my $image_base = $self->{path}->{image_base};
	my @images = map { basename($_)} glob( "$image_dir/*");
	unless ( defined $images[0] ){
		$res = {
			err => 1,
			template => '',
			message => '',
		};
		return $res;
	}
	@images =  sort {$b cmp $a } @images;
	$res = { images => \@images, image_base => $image_base};
	return $res;
}

sub store_images {
	my ( $self, $image) = @_;
	my $res = {};
	unless (defined $image){
		$res = {
			err => 1,
			template => 'error',
			message => 'Upload fail. File is not specifized.',
		};
		return $res;
	}
	my $upload_max_size = 3 * 1024 * 1024;
	if ($image->size > $upload_max_size ){
		$res = {
			err => 1,
			template => 'error',
			message => 'Upload fail. Image size is too big.',
		};
		return $res;
	}
	
	my $image_type = $image->headers->content_type;
	
	my %valid_types = map {$_ => 1} qw (image/gif image/jpeg image/png);
	unless ($valid_types{$image_type}){
		$res = {
			err => 1,
			template => 'error',
			message => 'Upload fail. Content Type is wrong',
		};
		return $res;
	}
	my $exts = {  'image/gif' => 'gif', 'image/jpeg' => 'jpg',
								'image/png' => 'png',	};

	my $ext = $exts->{$image_type};
	my $image_dir = $self->{path}->{image_dir};

	my $image_file = "$image_dir/" .  create_filename() . ".$ext";
	while (-f $image_file) {
		$image_file = "$image_dir/" .create_filename() . ".ext";
	}
	$image->move_to($image_file);
	$res = {
		err => 0,
		message => 'Upload succeded',
	};
	return $res;
}
	

sub create_filename {
	my $now = localtime;
	my $datestr = datestr($now, 'continus');
	my $rand_num = int(rand 100000);
	my $name = $datestr. "-" . $rand_num;
	return $name;
}

sub DESTROY {
	my $self = shift;
}
1;


