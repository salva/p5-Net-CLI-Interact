package Net::CLI::Interact::Transport::SSH;

{
    package # hide from pause
        Net::CLI::Interact::Transport::SSH::Options;
    use Moose;

    has 'host' => (
        is => 'rw',
        isa => 'Str',
        required => 1,
    );

    use Moose::Util::TypeConstraints;
    coerce 'Net::CLI::Interact::Transport::SSH::Options'
        => from 'HashRef[Any]'
            => via { Net::CLI::Interact::Transport::SSH::Options->new($_) };
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

use Moose;
extends 'Net::CLI::Interact::Transport';

has 'connect_options' => (
    is => 'ro',
    isa => 'Net::CLI::Interact::Transport::SSH::Options',
    coerce => 1,
    required => 1,
);

has 'app' => (
    is => 'ro',
    isa => 'Str',
    lazy_build => 1,
);

sub _build_app {
    my $self = shift;
    confess "please pass location of plink.exe in 'app' parameter to new()\n"
        if $^O eq 'MSWin32';
    return 'ssh'; # unix
}

sub runtime_options {
    return (
        ($^O eq 'MSWin32' ? '-ssh' : ()),
        (shift)->connect_options->host,
    );
}

1;

# ABSTRACT: SSH based CLI connection

=head1 DECRIPTION

This module provides an L<IPC::Run> wrapped instance of an SSH client for use
by L<Net::CLI::Interact>.

=head1 INTERFACE

=head2 app

On Windows platforms you B<must> download the C<plink.exe> program, and pass its
location to the library in this parameter. On other platforms, this defaults to
C<ssh>.

=head2 runtime_options

Based on the C<connect_options> hash provided to Net::CLI::Interact on
construction, selects and formats parameters to provide to C<app> on the
command line. Supported attributes:

=over 4

=item host (required)

Host name or IP address of the host to which the SSH application is to
connect.

=back

=head1 COMPOSITION

See the following for further interface details:

=over 4

=item *

L<Net::CLI::Interact::Transport>

=back

=cut