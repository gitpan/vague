use ExtUtils::MakeMaker;

# $Id: Makefile.PL,v 1.2 2001/12/19 07:11:26 piers Exp $

WriteMakefile(
	AUTHOR		=> 'P Kent (pause@selsyn.co.uk)',
	ABSTRACT	=> 'Add vagueness to any program',
	NAME		=> 'vague',
	DISTNAME	=> 'vague',
	dist		=> {
		COMPRESS	=> 'gzip',
		SUFFIX		=> '.gz',
	},
	VERSION_FROM	=> 'lib/vague.pm',
	PREREQ_PM	=> { },
	LIBS		=> [''],
	DEFINE		=> '',
	INC		=> '',
);

