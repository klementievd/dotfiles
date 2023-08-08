# -*- mode: makefile; -*-

##########################
# I use GNUmakefile
# for short commands
# like `make home' or
# `make disk-image'
##########################

# Default root variable
ROOT=/mnt

# Default `https://ci.guix.gnu.org' is unavailable in Russia
SUBSTITUTES=--substitute-urls='https://bordeaux.guix.gnu.org https://substitutes.nonguix.org'

# Specific options for Guix
OPTIONS=-L "./scheme"

# Run Guix with specific channels
GUIX=guix time-machine -C channels.scm --

# Initializing new system and copy dotfiles
init:
	${GUIX} system ${OPTIONS} init ${ROOT} system.scm ${SUBSTITUTES} # Initialize new system
	rm -rf ${ROOT}/etc/dotfiles # Remove dotfiles if exists
	mkdir -p ${ROOT}/etc/dotfiles # Make new dotfiles directory
	cp -r ./* ${ROOT}/etc/dotfiles/ # Copy dotfiles into new system

# Reconfigure new home environment
home:
	${GUIX} home ${OPTIONS} reconfigure home.scm ${SUBSTITUTES}

# Make system disk-image
disk-image:
	${GUIX} system ${OPTIONS} image disk-image.scm ${SUBSTITUTES}

################### Copying things ######################

about:
	@echo "dotfiles  Copyright (C) 2023 Klementiev Dmitry"
	@echo "This program comes with ABSOLUTELY NO WARRANTY; for details type \`show-w'."
	@echo "This is free software, and you are welcome to redistribute it"
	@echo "under certain conditions; type \`make show-c' for details."

show-w:
	@echo "THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY"
	@echo "APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT"
	@echo "HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM \"AS IS\" WITHOUT WARRANTY"
	@echo "OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,"
	@echo "THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR"
	@echo "PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM"
	@echo "IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF"
	@echo "ALL NECESSARY SERVICING, REPAIR OR CORRECTION."

show-c:
	@sed -n 71,621p COPYING
