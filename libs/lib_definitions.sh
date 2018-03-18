# Generic variables used by all libraries.
# Success is a variant on failure - best to define this too for consistency.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_DEFINITIONS=1;

# Return codes.
SUCCESS=0		#
E_DID_NOTHING=1		# Exit. No changes made to anything.
WRONG_PLATFORM=2	#
NO_CONFIG=3		# Crucial configuration file not found.

