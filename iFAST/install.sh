#!/bin/sh
# ==========================================================================================
# SolarWinds Agent offline installer
# Usage: Switch to this script's directory and execute it without parameters
# ------------------------------------------------------------------------------------------
# Exit codes:
# 0 ... success (no error was detected)

# unknown package type (looks like installation package is none of rpm or deb package)
ERROR_UNKNOW_PACKAGE_TYPE=1

# installation package was not found
ERROR_INST_PKG_NOT_FOUND=4

# there was found more than one installation package
ERROR_INST_PKG_NOT_UNIQUE=5

# service command was not found
ERROR_SERVICE_CMD_NOT_FOUND=6

# other agent is already installed
ERROR_OTHER_AGENT_INSTALLED=7

# package command (rpm or dpkg) not found
ERROR_PKG_COMMAND_NOT_FOUND=8

# cannot create temporary directory
ERROR_CANNOT_CREATE_TMP_DIR=9

# command tr not found
ERROR_TR_COMMAND_NOT_FOUND=10

# command wc not found
ERROR_WC_COMMAND_NOT_FOUND=11

# command base64 not found
ERROR_BASE64_COMMAND_NOT_FOUND=12

# package installation error
ERROR_INSTALLATION=13

# agent initialization failed
ERROR_INITIALIZATION=14

# agent start failed
ERROR_START=15

# unknown option given on command line
ERROR_UNKNOWN_OPTION=126

# internal error
ERROR_INTERNAL=127

# ------------------------------------------------------------------------------------------
# Environment variables used by this script:
# DEBUG ... when not empty, script dumps lot of debugging informations to stderr
#
# In some environments can be missing some important commands. In case of autodetection
# of such commands fails, they may be specified with dedicated environment variables.
# Content of such variable is always used with highest priority (e.g. no search for command
# is performed). Following environment variables/commands are supported:
# CMD_WHICH .... for 'which' command
# CMD_MKTEMP ... for 'mktemp' command
# CMD_RPM ...... for 'rpm' command
# CMD_DPKG ..... for 'dpkg' command
# CMD_TR ....... for 'tr' command
# CMD_WC ....... for 'wc' command
# CMD_BASE64 ... for 'base64 -d -i -' command (must read stdin and write to stdout)
# ==========================================================================================

debug()
{
    [ "${DEBUG}" != "" ]
}

debug_msg()
{
    if debug; then
        >&2 echo "$@"
        if [ "${INST_LOG}" != "" ]; then
            echo "$@" >> "${INST_LOG}"
        fi
    fi
}

show_help()
{
    >&2 echo "SolarWinds Orion Agent offline installer"
    >&2 echo "Usage:"
    >&2 echo "  switch to directory containing this script and execute it without parameters:"
    >&2 echo "  ./install.sh"
    >&2 echo
    >&2 echo "Additional options:"
    >&2 echo "  -h"
    >&2 echo "  --help ....... show this help"
    >&2 echo
    >&2 echo "  -k"
    >&2 echo "  --keep-log ... do not delete installation log even if installer succeeds"
    >&2 echo
}

parse_options()
{
    debug_msg "parse_options: $@"

    # Set defaults
    OPT_KEEP_LOG=

    while [ $# -gt 0 ]; do
        CMD="$1"
        shift

        case "${CMD}" in
            -h|--help)
                show_help
                exit 0
                ;;

            -k|--keep-log)
                OPT_KEEP_LOG=1
                ;;

            *)
                >&2 echo "Unknown option '${CMD}'"
                >&2 echo
                show_help
                exit $ERROR_UNKNOWN_OPTION
        esac
    done

    debug_msg "parse_options: done"
    debug_msg "OPT_KEEP_LOG='${OPT_KEEP_LOG}'"
    debug_msg "----------------------------------------"
}

cleanup()
{
    debug_msg "Cleanup"
    if [ "${OPT_KEEP_LOG}" = "" ] && [ "${TMP_DIR}" != "" ]; then
        rm -Rf "${TMP_DIR}" >&2
    else
        >&2 echo "Installation log is in '${INST_LOG}'"
    fi
}

set_environment()
{
    if debug; then
        DEBUG_REDIRECTION=""
    else
        DEBUG_REDIRECTION="2>/dev/null"
    fi

    # Add additional paths where to search for commands - they may differ according to OS
    WELL_KNOWN_PATHS=". /bin /usr/bin /usr/sbin /sbin /usr/local/bin /usr/local/sbin"
    UNAME_RESULT=`uname`
    case "${UNAME_RESULT}" in
        [aA][iI][xX])
            WELL_KNOWN_PATHS="${WELL_KNOWN_PATHS} /usr/linux/bin /opt/freeware/bin"
        ;;
    esac
    debug_msg "Setting WELL_KNOWN_PATHS for '${UNAME_RESULT}' to '${WELL_KNOWN_PATHS}'"

    # Check for which command - here cannot be used find_command function, because it uses CMD_WHICH
    if [ "${CMD_WHICH}" != "" ]; then
        debug_msg "CMD_WHICH used from environment: '${CMD_WHICH}'"
    else
        CMD_WHICH=`/bin/sh -c "which --skip-alias which ${DEBUG_REDIRECTION}"`
        if [ "$?" = "0" ]; then
            # Which was found and supports parameter --skip-alias
            CMD_WHICH="which --skip-alias"
        else
            # Which was either not found or does not support --skip-alias parameter, retry without options
            CMD_WHICH=`/bin/sh -c "which which ${DEBUG_REDIRECTION}"`
            if [ "${CMD_WHICH}" = "" ]; then
                # No which was found - use own simplified version
                CMD_WHICH=local_which
            fi
        fi
    fi

    # Check for mktemp command. local_mktemp_dir supports only creating of temporary directory in /tmp, which is enough
    if [ "${CMD_MKTEMP}" != "" ]; then
        debug_msg "CMD_MKTEMP used from environment: '${CMD_MKTEMP}'"
    else
        CMD_MKTEMP=`find_command mktemp` || CMD_MKTEMP="local_mktemp_dir"
    fi

    # Check for rpm and dpkg. It is expected that only one of them is present - they are checked later only when needed.
    if [ "${CMD_RPM}" != "" ]; then
        debug_msg "CMD_RPM used from environment: '${CMD_RPM}'"
    else
        CMD_RPM=`find_command rpm`
    fi

    if [ "${CMD_DPKG}" != "" ]; then
        debug_msg "CMD_DPKG used from environment: '${CMD_DPKG}'"
    else
        CMD_DPKG=`find_command dpkg`
    fi

    # Check for tr command. It is needed only when standard which command is not found and we are searching for command without path,
    # so the result is not checked here.
    if [ "${CMD_TR}" != "" ]; then
        debug_msg "CMD_TR used from environment: '${CMD_TR}'"
    else
        CMD_TR=`find_command tr`
    fi

    # Check for wc command
    if [ "${CMD_WC}" != "" ]; then
        debug_msg "CMD_WC used from environment: '${CMD_WC}'"
    else
        CMD_WC=`find_command wc` || { >&2 echo "Command 'wc' not found."; exit ${ERROR_WC_COMMAND_NOT_FOUND}; }
    fi

    # Check for working base64 decoding command (it must accept stdin for input and write its output to stdout)
    if [ "${CMD_BASE64}" != "" ]; then
        debug_msg "CMD_BASE64 used from environment: '${CMD_BASE64}'"
    else
        check_base64 "`find_command base64`" -d -i -
        if [ "${CMD_BASE64}" = "" ]; then        
            check_base64 local_base64_decode
            if [ "${CMD_BASE64}" = "" ]; then
                >&2 echo "Command 'base64' not found."
                exit ${ERROR_BASE64_COMMAND_NOT_FOUND}
            fi
        fi
    fi

    # -----------------------------------------------------------------------------------------------------------
    
    # Create temporary directory where are extracted embedded files
    TMP_DIR=`"${CMD_MKTEMP}" -d`
    if [ "${TMP_DIR}" = "" ]; then
        debug_msg "mktemp returned empty result"
        exit ${ERROR_CANNOT_CREATE_TMP_DIR}
    fi

    # Set paths to some used files
    DATA_DIR="./data"

    CA_CERT_FILE="${TMP_DIR}/ca_cert.crt"
    PROV_CERT_FILE="${TMP_DIR}/provisioning.pfx"
    INI_FILE="${TMP_DIR}/SolarWindsAgent.ini"
    
    INST_LOG="${TMP_DIR}/swiagent-install.log"

    SWI_AGENT_AID="/opt/SolarWinds/Agent/bin/swiagentaid.sh"
}

# Try to find command in PATH or in any directory given by $2, $3, ...
# $1 ... command to search for
# rest of parameters
find_command_x()
{
    # Command to find
    CMD="$1"
    shift

    # First try to find it in current PATH
    debug_msg "find_command_x: /bin/sh -c \"${CMD_WHICH} \\\"${CMD}\\\" ${DEBUG_REDIRECTION}\""
    RES=`/bin/sh -c "${CMD_WHICH} \"${CMD}\" ${DEBUG_REDIRECTION}"`
    if [ "${RES}" != "" ]; then
        debug_msg "find_command_x: Found ${RES}"
        echo "${RES}"
        return 0
    fi

    # Try to find it in additional paths given as subsequent parameters
    while [ "$#" != "0" ]; do
        debug_msg "find_command_x: /bin/sh -c \"${CMD_WHICH} \\\"$1/${CMD}\\\" ${DEBUG_REDIRECTION}\""
        RES=`/bin/sh -c "${CMD_WHICH} \"$1/${CMD}\" ${DEBUG_REDIRECTION}"`
        if [ "${RES}" != "" ]; then
            debug_msg "find_command_x: Found ${RES}"
            echo "${RES}"
            return 0
        fi
        shift
    done

    debug_msg "find_command_x: ${CMD} not found"
    return 1
}

# Try to find command in PATH, WELL_KNOWN_PATHS and additional directories given as $2, $3, ...
# $1 ... command to search for
# rest of parameters ... additional search paths
# It is just a wrapper for find_command_x adding ${WELL_KNOWN_PATHS}
find_command()
{
    if [ "$#" = "0" ]; then
        >&2 echo "No arguments passed to find_command function"
        >&2 echo "Usage: find_command command [alternate-dir1] [alternate-dir2] ... [alternate-dirn]"
        exit ${ERROR_INTERNAL}
    fi

    # Command to find
    CMD="$1"
    shift

    find_command_x "${CMD}" ${WELL_KNOWN_PATHS} "$@"
}

# Own implementation of which command - it is used only when no which command is found
local_which()
{
    if [ "$#" = "0" ]; then
        >&2 echo "No arguments passed to local_which function"
        >&2 echo "Usage: local_which command"
        exit ${ERROR_INTERNAL}
    fi

    CMD="$1"

    debug_msg "local_which: CMD='${CMD}'"

    case "${CMD}" in
        */*)# Command contains PATH delimiter - consider it full path or relative path
            if [ -x "${CMD}" ]; then
                echo "${CMD}"
                return 0
            fi
            return 1
        ;;

        *)  # No PATH delimiter, try to find command in directories specified by PATH env variable
            if [ "${CMD_TR}" = "" ]; then
                >&2 echo "Command 'tr' not found."
                exit ${ERROR_TR_COMMAND_NOT_FOUND}
            fi
            
            echo ${PATH} | "${CMD_TR}" ':' '\n' | while read dir; do
                if [ -x "${dir}/${CMD}" ]; then
                    echo "${dir}/${CMD}"
                    break
                fi
            done
        ;;
    esac
}

# Own implementation of "mktemp -d" - it is used only when no mktemp is found
local_mktemp_dir()
{
    REMAINING_ATTEMPTS=20
    while true; do
        TEMP_NAME="/tmp/swiagent-${RANDOM}-$$"
        if [ ! -e "${TEMP_NAME}" ] && mkdir "${TEMP_NAME}" >/dev/null; then
            echo ${TEMP_NAME}
            return
        fi
        
        REMAINING_ATTEMPTS=`expr ${REMAINING_ATTEMPTS} - 1`
        if [ "${REMAINING_ATTEMPTS}" -eq "0" ]; then
            >&2 echo "Fatal: Cannot create temporary directory"
            exit ${ERROR_CANNOT_CREATE_TMP_DIR}
        fi
    done
}

# Own implementation of "base64 -d" - it is used only when no working base64 is found and when perl with module MIME::Base64 is available
local_base64_decode()
{
    perl -MMIME::Base64 -e 'undef $\; print decode_base64(<>);'
}

test_installed_rpm()
{
    if [ "${CMD_RPM}" = "" ]; then
        >&2 echo "Cannot find rpm command"
        exit ${ERROR_PKG_COMMAND_NOT_FOUND}
    fi
    "${CMD_RPM}" -q "$1"
}

test_installed_deb()
{
    if [ "${CMD_DPKG}" = "" ]; then
        >&2 echo "Cannot find dpkg command"
        exit ${ERROR_PKG_COMMAND_NOT_FOUND}
    fi
    "${CMD_DPKG}" -s "$1" | grep -e 'Status: .* installed'
}

# Sample text for checking base64 decoder works correctly
DECODED_BASE64_SAMPLE="base64 test"
ENCODED_BASE64_SAMPLE="YmFzZTY0IHRlc3Q="

check_base64()
{
    debug_msg "check_base64: $@"

    if [ "$1" = "" ]; then
        debug_msg "check_base64: empty command"
        return 1
    fi

    # Try to decode sample and compare it with expected value
    if [ "`echo \"${ENCODED_BASE64_SAMPLE}\" | \"$@\"`" = "${DECODED_BASE64_SAMPLE}" ]; then
        CMD_BASE64="$@"
        return 0
    fi

    # Decoder did not return expected result
    CMD_BASE64=""
    return 1
}

main()
{
    if debug; then
        >&2 pwd
        >&2 ls -la
        >&2 echo
    fi

    debug_msg "SWI_AGENT_AID=${SWI_AGENT_AID}"

    INSTALL_PACKAGE=`find "${DATA_DIR}" -name '*.rpm' -print; find "${DATA_DIR}" -name '*.deb' -print`
    debug_msg "Install package: ${INSTALL_PACKAGE}"

    if [ "${INSTALL_PACKAGE}" = "" ]; then
        >&2 echo "Cannot find any install package."
        exit ${ERROR_INST_PKG_NOT_FOUND}
    fi

    # This works only when DATA_DIR and package name does not contain any new-line characters
    PACKAGE_COUNT=`echo "${INSTALL_PACKAGE}" | "${CMD_WC}" -l`

    debug_msg "Found ${PACKAGE_COUNT} package(s)"

    if [ "${PACKAGE_COUNT}" -ne "1" ]; then
        >&2 echo "Cannot determine which package from
${INSTALL_PACKAGE}
should be installed - only one install package is expected"
        exit ${ERROR_INST_PKG_NOT_UNIQUE}
    fi

    PACKAGE=`basename "${INSTALL_PACKAGE}"`
    debug_msg "PACKAGE=${PACKAGE}"

    PACKAGE_TYPE=${PACKAGE##*.}
    debug_msg "PACKAGE_TYPE=${PACKAGE_TYPE}"

    if [ "${PACKAGE_TYPE}" = "rpm" ]; then
        INSTALL="${CMD_RPM} -Uvh"
    elif [ "${PACKAGE_TYPE}" = "deb" ]; then
        INSTALL="${CMD_DPKG} -i"
    else
        >&2 echo "Unknown package type ${PACKAGE_TYPE}"
        exit ${ERROR_UNKNOW_PACKAGE_TYPE}
    fi
    debug_msg "INSTALL=${INSTALL}"

    if "test_installed_${PACKAGE_TYPE}" swiagent >>"${INST_LOG}" 2>&1; then
        >&2 echo "Cannot install agent: other agent is already installed"
        RES=${ERROR_OTHER_AGENT_INSTALLED}
    else
        if [ "`id -u 2>/dev/null`" = "0" ]; then
            >&2 echo "Starting the installation."
            ESH='/bin/sh'
        else
            >&2 echo "Starting the installation. You will be prompted for root credentials."
            ESH='su'
        fi

        INSTALL_CMD=`cat <<END_OF_INSTALL_CMD
        echo "Installing package '${INSTALL_PACKAGE}'"
        ${INSTALL} "${INSTALL_PACKAGE}"
        ec=\\\$?
        if [ "\\\$ec" != "0" ]; then
            echo "Package installation failed with exit code '\\\$ec'"
            exit $ERROR_INSTALLATION
        fi
        
        echo "Initializing agent"
        ${SWI_AGENT_AID} init /installcert /s iniFile="${INI_FILE}" ca_cert="${CA_CERT_FILE}" cert="${PROV_CERT_FILE}"
        ec=\\\$?
        if [ "\\\$ec" != "0" ]; then
            echo "Agent initialization failed with exit code '\\\$ec'"
            exit $ERROR_INITIALIZATION
        fi

        WAIT_COUNTER=6
        while [ "\\\${WAIT_COUNTER}" -gt "0" ]; do
            sleep 5
            echo "Checking status of agent service"
            ${SWI_AGENT_AID} status swiagentd
            if [ "\\\$?" = "0" ]; then
                echo "Agent service is running - installation is finished"
                exit 0
            fi

            WAIT_COUNTER=\\\`expr \\\${WAIT_COUNTER} - 1\\\`
            echo "Agent service not yet running, waiting will continue (\\\${WAIT_COUNTER} attempts remaining)"
        done

        echo "Agent service did not start yet - force to start it"
        ${SWI_AGENT_AID} start swiagentd
        ec=\\\$?
        if [ "\\\$ec" != "0" ]; then
            echo "Start of agent service failed with exit code '\\\$ec'"
            exit $ERROR_START
        fi
END_OF_INSTALL_CMD
`

        debug_msg "${ESH} -c \"${INSTALL_CMD}\""

        ${ESH} -c "( ${INSTALL_CMD} ) >>\"${INST_LOG}\" 2>&1"
        RES="$?"
    fi

    if [ "${RES}" = "0" ]; then
        >&2 echo "Installation finished"
        debug && ps -ef | grep Solar | grep -v grep >&2
    else
        >&2 echo "Installation failed (${RES})"
        OPT_KEEP_LOG=1
    fi

    return "${RES}"
}

parse_options "$@"
set_environment
trap cleanup EXIT

${CMD_BASE64} > "${CA_CERT_FILE}" <<END_OF_CA_CERT
MIIDJTCCAg2gAwIBAgIQ8rksKLCBaI5J0A5WNgMRBDANBgkqhkiG9w0BAQsFADAbMRkwFwYDVQQDExBTb2xhcldpbmRzLU9yaW9uMB4XDTE3MDkxMjIxMzIzOVoXDTM5MTIzMTIzNTk1OVowGzEZMBcGA1UEAxMQU29sYXJXaW5kcy1PcmlvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKTGpch1S2FaIgK3fm4icxeLKF9Csi5lJjJMaHZMvpwwt2821gWk1t79I6Ja4G45w8bqSyMUZz6cykjjv98AYUqrGcFmQ7gJ/zJxOxXVBKsVIJF1O7gPSaY65hx1jqR6LrgeydyOh02A1ElY8CImOyu4CjUywNR/CA8o0KKEhyrBFZ+aZvSjG98P9++rYKFhxyMu5AGPCN88nQlbsxVS5UQXXmxDE/dDKx9cyTTokUMTGhrt+qNuOgXs+Ltg58WiaXTD1sVi/9k5dL5LwYZ8JKdmS9SHlrDBCpob2Q0zmU3Z1jQu7VwvwYztEIlA9/y6+C0DBewX5+71uUZD6U5uwGcCAwEAAaNlMGMwEwYDVR0lBAwwCgYIKwYBBQUHAwEwTAYDVR0BBEUwQ4AQyRHA+0s5lsVTcy8Gbl0TpaEdMBsxGTAXBgNVBAMTEFNvbGFyV2luZHMtT3Jpb26CEPK5LCiwgWiOSdAOVjYDEQQwDQYJKoZIhvcNAQELBQADggEBAJEmcKBjvHdYs6+XdtcjCiG1064vT9JE2l0Fn1Byt/++1YUToarNHA+nTkF+YYMAUQFVLZinx5G1kqXEn5la0WTY47dPcJJ7zDbezklPjMMYexadVXHZanhoa07VahpNLOMfql7IJe+QqpsXQt/6hTJDQ1CMLaQSQoKsVoH2Lblfc1JgBabGZAHXNAHrrs50ZF2e1S54MekM+nAVSQVe7jDyTilFBt+lY1hwiXNI6GnZQMzO0quczlY4F6yKzziYHmtKbmNQlL9zsO+IOQeVTltLQwglctOf84KBldORM9sswZYoJk/76RzJb1xVbsq5CBgPanh7ywn0eCyC39cw7Yo=
END_OF_CA_CERT

${CMD_BASE64} > "${PROV_CERT_FILE}" <<END_OF_CERT
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
END_OF_CERT

cat > "${INI_FILE}" <<END_OF_INIFILE
[parameters]
installcert=true
run_provision=true
relative_path=ini
ca_cert=ca.cer
cert=provisioning.pfx
ca_pwd=true
target=DRTW-SAM
port=17778
ipaddress=105.52.72.227,::1
targetDeviceID=00000000-0000-0000-0000-000000000000
is_active=true
server_http_port=17790
proxy_access_type=disabled

END_OF_INIFILE

main
