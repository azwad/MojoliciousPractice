#!/usr/local/bin/morbo
use Mojolicious::Lite;
use feature qw( say );

my $site_title = 'Mojolicious Practice';

my ($dir1, $title1, $model1, $template1) = ('plane_text', 'Plane Text', 'plane_text', 'plane_text');
my ($dir2, $title2, $model2, $template2) = ('image_bbs', 'Image BBS', 'image_bbs', 'image_bbs');
my ($dir3, $title3, $model3, $template3) = ('upload_image', 'Upload Image', 'upload_image', 'upload_image');
my ($dir4, $title4, $model4, $template4) = ('bbs', 'BBS', 'bbs', 'bbs');
my ($dir5, $title5, $model5, $template5) = ('write_message', 'Write Message', 'write_message', 'write_message');
my ($dir6, $title6, $model6, $template6) = ('plane_text', 'plane text', 'plane_text', 'plane_text');

get '/' => sub{
	my $self = shift;
	my $page_title = 'Main Menu';
	my $link = {
			$title1 => $dir1,
			$title2 => $dir2,
#			$title3 => $dir3,
			$title4 => $dir4,
#			$title5 => $dir5,
	};
	$self->stash(
		site_title => $site_title,
		page_title => $page_title,
		link => $link,
	);
	$self->render(	);
} => 'menu';

get $dir1 => sub {
	my $self = shift;
	my $package_name = "model-$model1.pm";
	my $app_object_name = "Model::$model1";
	require $package_name;
	app->helper(
		$model1 =>sub {
			$app_object_name->new;
	});
	my $input = "test";
	my $res = $self->app->$model1->method( $input ) or return $self->redirect_to($dir1);
	$self->stash(
		result => $res,
		site_title => $site_title,
		page_title => $title1,
	);
	$self->render( );
} => $template1;


get $dir2 => sub {
	my $self = shift;
	my $package_name = "model-$model2.pm";
	my $app_object_name = "Model::$model2";
	require $package_name;
	app->helper(
		$model2 =>sub {
			$app_object_name->new;
	});
#	my $input = ;
	my $method = 'view_images';
	my $res = $self->app->$model2->$method() or return $self->redirect_to($dir2);
	$self->stash(
		result => $res,
		site_title => $site_title,
		page_title => $title2,
	);
	$self->render( );
} => $template2;

post $dir3 => sub {
	my $self = shift;
	my $package_name = "model-$model2.pm";
	my $app_object_name = "Model::$model2";
	require $package_name;
	app->helper(
		$model2 =>sub {
			$app_object_name->new;
	});
	my $input = $self->req->upload('image');
	my $method = 'store_images';
	my $res = $self->app->$model2->$method( $input ) or return $self->redirect_to($dir2);
	if ($res->{err}){
		return $self->render(
			site_title => $site_title,
			page_title => 'Error Page',
			template => $res->{template},
			message  => $res->{message},
		);
	} 
	$self->redirect_to($dir2);
} => $template3;


get $dir4 => sub {
	my $self = shift;
	my $package_name = "model-$model4.pm";
	my $app_object_name = "Model::$model4";
	require $package_name;
	app->helper(
		$model4 =>sub {
		$app_object_name->new;
	});
	#my $input = ;
	my $method = 'view_message';
	my $res = $self->app->$model4->$method() or return $self->redirect_to($dir4);
	$self->stash(
		result => $res,
		site_title => $site_title,
		page_title => $title4,
	);
	$self->render( );
} => $template4;


post $dir5 => sub {
	my $self = shift;
	my $package_name = "model-$model4.pm";
	my $app_object_name = "Model::$model4";
	require $package_name;
	app->helper(
		$model4 =>sub {
		$app_object_name->new;
	});
	my $input = {
		title => $self->param('title'),
		message => $self->param('message'),
	};
	my $method = 'write_message';
	my $res = $self->app->$model4->$method( $input ) or return $self->redirect_to($dir4);
	if ($res->{err}){
		return $self->render(
			site_title => $site_title,
			page_title => 'Error Page',
			template => $res->{template},
			message  => $res->{message},
		);
	}
	$self->redirect_to($dir4);
};


app->start;
