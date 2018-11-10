# NAME

MooX::Const - Syntactic sugar for creating constant Moo attributes

# VERSION

version v0.1.1

# SYNOPSIS

```perl
use Moo;
use MooX::Const;

has thing => (
  is  => 'const',
  isa => ArrayRef[HashRef],
);
```

# DESCRIPTION

This is syntactic sugar for using [Types::Const](https://metacpan.org/pod/Types::Const) with [Moo](https://metacpan.org/pod/Moo).

It modifies the `has` function to support "const" attributes.  These
are read-only ("ro") attributes for references, where the underlying
data structure has been set as read-only.

This will return an error if there is no "isa", the "isa" is not a
[Type::Tiny](https://metacpan.org/pod/Type::Tiny) type, if it is not a reference, or if it is blessed
object.

Simple value types such as `Int` or `Str` are silently converted to
read-only attributes.

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

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
