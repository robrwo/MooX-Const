package MooX::Const;

# ABSTRACT: Syntactic sugar for constant and write-once Moo attributes

use utf8;
use v5.10.1;

use Carp qw( croak );
use Devel::StrictMode;
use Moo       ();
use Moo::Role ();
use Scalar::Util qw/ blessed /;
use Types::Const qw( Const );
use Types::Standard qw( Value Object Ref );

# RECOMMEND PREREQ: Types::Const v0.3.6
# RECOMMEND PREREQ: Type::Tiny::XS
# RECOMMEND PREREQ: MooX::TypeTiny

use namespace::autoclean;

our $VERSION = 'v0.4.1';

=head1 SYNOPSIS

  use Moo;
  use MooX::Const;

  use Types::Standard -types;

  has thing => (
    is  => 'const',
    isa => ArrayRef[HashRef],
  );

=head1 DESCRIPTION

This is syntactic sugar for using L<Types::Const> with L<Moo>. The
SYNOPSIS above is equivalent to:

  use Types::Const -types;

  has thing => (
    is     => 'ro',
    isa    => Const[ArrayRef[HashRef]],
    coerce => 1,
  );

It modifies the C<has> function to support "const" attributes.  These
are read-only ("ro") attributes for references, where the underlying
data structure has been set as read-only.

This will return an error if there is no "isa", the "isa" is not a
L<Type::Tiny> type, if it is not a reference, or if it is blessed
object.

Simple value types such as C<Int> or C<Str> are silently converted to
read-only attributes.

As of v0.2.0, it also supports write-once ("wo") attributes for
references:

  has setting => (
    is  => 'wo',
    isa => HashRef,
  );

This allows you to set the attribute I<once>. The value is coerced
into a constant, and cannot be changed again.

As of v0.4.0, this now supports the C<strict> setting:

  has thing => (
    is     => 'const',
    isa    => ArrayRef[HashRef],
    strict => 0,
  );

When this is set to a false value, then the read-only constraint will
only be applied when running in strict mode, see L<Devel::StrictMode>.

If omitted, C<strict> is assumed to be true.

=cut

sub import {
    my $class = shift;

    my $target = caller;

    my $installer =
      $target->isa("Moo::Object")
      ? \&Moo::_install_tracked
      : \&Moo::Role::_install_tracked;

    if ( my $has = $target->can('has') ) {
        my $new_has = sub {
            $has->( _process_has(@_) );
        };
        $installer->( $target, "has", $new_has );
    }

}

sub _process_has {
    my ( $name, %opts ) = @_;

    my $strict = STRICT || ( $opts{strict} // 1 );

    my $is = $opts{is};

    if ($is && $is =~ /^(?:const|wo)$/ ) {

        if ( my $isa = $opts{isa} ) {

            unless ( blessed($isa) && $isa->isa('Type::Tiny') ) {
                croak "isa must be a Type::Tiny type";
            }

            if ($isa->is_a_type_of(Value)) {

                if ($is eq 'wo') {

                    croak "write-once attributes are not supported for Value types";

                }
                else {

                    $opts{is}  = 'ro';

                }

            }
            else {

                unless ( $isa->is_a_type_of(Ref) ) {
                    croak "isa must be a type of Types::Standard::Ref";
                }

                if ( $isa->is_a_type_of(Object) ) {
                    croak "isa cannot be a type of Types::Standard::Object";
                }

                if ($strict) {
                    $opts{isa} = Const[$isa];
                    $opts{coerce} = $opts{isa}->coercion;
                }

                if ($opts{trigger} && ($is ne 'wo')) {
                    croak "triggers are not applicable to const attributes";
                }

                $opts{is}  = $is eq 'wo' ? 'rw' : 'ro';

            }

        }
        else {

            croak "Missing isa for a const attribute";

        }

    }

    return ( $name, %opts );
}

=head1 KNOWN ISSUES

Accessing non-existent keys for hash references will throw an
error. This is a feature, not a bug, of read-only hash references, and
it can be used to catch mistakes in code that refer to non-existent
keys.

Unfortunately, this behaviour is not replicated with array references.

=head1 SEE ALSO

L<Const::Fast>

L<Devel::StrictMode>

L<Moo>

L<Types::Const>

L<Type::Tiny>

=encoding utf8

=head1 append:AUTHOR

This module was inspired by suggestions from Kang-min Liu 劉康民
<gugod@gugod.org> in a L<blog post|http://blogs.perl.org/users/robert_rothenberg/2018/11/typeconst-released.html>.

=cut

1;
