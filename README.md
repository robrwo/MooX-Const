# NAME

MooX::Const - Syntactic sugar for constant and write-once Moo attributes

# VERSION

version v0.2.3

# SYNOPSIS

```perl
use Moo;
use MooX::Const;

use Types::Standard -types;

has thing => (
  is  => 'const',
  isa => ArrayRef[HashRef],
);
```

# DESCRIPTION

This is syntactic sugar for using [Types::Const](https://metacpan.org/pod/Types::Const) with [Moo](https://metacpan.org/pod/Moo). The
SYNOPSIS above is equivalent to:

```perl
use Types::Const -types;

has thing => (
  is     => 'ro',
  isa    => Const[ArrayRef[HashRef]],
  coerce => 1,
);
```

It modifies the `has` function to support "const" attributes.  These
are read-only ("ro") attributes for references, where the underlying
data structure has been set as read-only.

This will return an error if there is no "isa", the "isa" is not a
[Type::Tiny](https://metacpan.org/pod/Type::Tiny) type, if it is not a reference, or if it is blessed
object.

Simple value types such as `Int` or `Str` are silently converted to
read-only attributes.

As of v0.2.0, it also supports write-once ("wo") attributes for
references:

```perl
has setting => (
  is  => 'wo',
  isa => HashRef,
);
```

This allows you to set the attribute _once_. The value is coerced
into a constant, and cannot be changed again.

# ROADMAP

Support for Perl versions earlier than 5.10 will be removed sometime
in 2019.

# SEE ALSO

[Moo](https://metacpan.org/pod/Moo)

[Types::Const](https://metacpan.org/pod/Types::Const)

[Type::Tiny](https://metacpan.org/pod/Type::Tiny)

# SOURCE

The development version is on github at [https://github.com/robrwo/MooX-Const](https://github.com/robrwo/MooX-Const)
and may be cloned from [git://github.com/robrwo/MooX-Const.git](git://github.com/robrwo/MooX-Const.git)

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://github.com/robrwo/MooX-Const/issues](https://github.com/robrwo/MooX-Const/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

This module was inspired by suggestions from Kang-min Liu 劉康民
<gugod@gugod.org> in a [blog post](http://blogs.perl.org/users/robert_rothenberg/2018/11/typeconst-released.html).

# CONTRIBUTOR

Kang-min Liu 劉康民 <gugod@gugod.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
