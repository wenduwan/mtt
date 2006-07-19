#!/usr/bin/env perl
#
# Copyright (c) 2005-2006 The Trustees of Indiana University.
#                         All rights reserved.
# Copyright (c) 2006      Cisco Systems, Inc.  All rights reserved.
# $COPYRIGHT$
# 
# Additional copyrights may follow
# 
# $HEADER$
#

package MTT::Test::Build::Trivial;

use strict;
use Cwd;
use File::Temp qw(tempfile);
use MTT::Messages;
use MTT::DoCommand;
use MTT::Values;
use Data::Dumper;

#--------------------------------------------------------------------------

sub _do_compile {
    my ($wrapper, $in_name, $out_name) = @_;

    # Do the compile
    my $x = MTT::DoCommand::Cmd(1, "$wrapper $in_name -o $out_name");
    if ($x->{status} != 0) {
        my $ret;
        $ret->{success} = 0;
        $ret->{result_message} = "Failed to compile/link $out_name\n";
        $ret->{stdout} = $x->{stdout};
        return $ret;
    }

    # All done
    return undef;
}

#--------------------------------------------------------------------------

sub Build {
    my ($ini, $mpi_install, $config) = @_;
    my $ret;
    my $x;

    Debug("Building Trivial\n");
    $ret->{success} = 0;

    # Try compiling and linking a simple C application

    if ($mpi_install->{c_bindings}) {
        Debug("Test compile/link sample C MPI application\n");
        $x = _do_compile("mpicc", "hello.c", "c_hello");
        return $x
            if (defined($x));
    } else {
        Debug("MPI C bindings unavailable; skipping simple compile/link test\n");
    }

    # If we have the C++ MPI bindings, try and compile and link a
    # simple C++ application

    if ($mpi_install->{cxx_bindings}) {
        Debug("Test compile/link sample C++ MPI application\n");
        $x = _do_compile("mpic++", "hello.cc", "cxx_hello");
        return $x
            if (defined($x));
    } else {
        Debug("MPI C++ bindings unavailable; skipping simple compile/link test\n");
    }

    # If we have the F77 MPI bindings, try compiling and linking a
    # simple F77 application

    if ($mpi_install->{f77_bindings}) {
        Debug("Test compile/link sample F77 MPI application\n");
        $x = _do_compile("mpif77", "hello.f", "f77_hello");
        return $x
            if (defined($x));
    } else {
        Debug("MPI F77 bindings unavailable; skipping simple compile/link test\n");
    }

    # If we have the F90 MPI bindings, try compiling and linking a
    # simple F90 application

    if ($mpi_install->{f90_bindings}) {
        Debug("Test compile/link sample F90 MPI application\n");
        $x = _do_compile("mpif90", "hello.f90", "f90_hello");
        return $x
            if (defined($x));
    } else {
        Debug("MPI F90 bindings unavailable; skipping simple compile/link test\n");
    }

    # All done
    $ret->{success} = 1;
    $ret->{result_message} = "Success";
    return $ret;
} 

1;